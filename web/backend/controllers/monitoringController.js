import fs from "fs";
import path from "path";
import axios from "axios";
import { fileURLToPath } from "url";
import { runMonitoringScript } from "../services/scriptService.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const jsonPath = process.env.MONITOR_PATH
    ? `${process.env.MONITOR_PATH}/system_data.json`
    : path.join(
          __dirname,
          "../monitoring/system_data.json"
      );
      
const getMonitoringData = (req, res) => {
    try {
        console.log("Reading monitoring data");
        const data = JSON.parse(
            fs.readFileSync(jsonPath, "utf8")
        );

        res.status(200).json(data);
    } catch (error) {
        res.status(500).json({
            message: "Unable to read monitoring data"
        });
    }
};


const refreshMonitoringData = async (req, res) => {
    try {
        //await runMonitoringScript();
        // await axios.post(
        //     "http://host.docker.internal:9000/run-monitor"
        // );
        await axios.post("http://172.17.0.1:9000/run-monitor");

        const data = JSON.parse(
            fs.readFileSync(jsonPath, "utf8")
        );

        res.status(200).json(data);

    } catch (error) {

        res.status(500).json({
            message: error.message
        });

    }
};


export {
    getMonitoringData,
    refreshMonitoringData
};