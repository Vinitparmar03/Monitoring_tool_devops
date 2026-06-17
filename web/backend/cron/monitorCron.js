import cron from "node-cron";
import path from "path";
import fs from "fs";
import axios from "axios";

import { fileURLToPath } from "url";

import { runMonitoringScript } from "../services/scriptService.js";
import { sendAlertEmail } from "../services/emailService.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

cron.schedule("*/1 * * * *", async () => {

    console.log("Running Monitoring Job");

    try {

        await axios.post("http://host.docker.internal:9000/run-monitor");
        
        const filePath =
            process.env.MONITOR_PATH
                ? `${process.env.MONITOR_PATH}/data.txt`
                : path.join(
                      __dirname,
                      "../monitoring/data.txt"
                  );

        if (!fs.existsSync(filePath)) {
            console.log("data.txt not found");
            return;
        }

        const content = fs.readFileSync(
            filePath,
            "utf8"
        );

        const lines = content
            .split("\n")
            .filter(line => line.trim());

        if (lines.length > 1) {

            console.log("Critical Alert Found");

            await sendAlertEmail(filePath);

        } else {

            console.log("No Critical Alerts");

        }

    } catch (error) {

        console.error(
            "Cron Job Error:",
            error.message
        );

    }

});