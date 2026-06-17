import express from "express";
import { exec } from "child_process"

const app = express();

app.post("/run-monitor", (req, res) => {
    
    console.log("Current Directory:", process.cwd());

    exec(
        "bash /home/vinit-kumar-parmar/Desktop/project/monitoring/script/monitoring_script.sh",
        (error, stdout, stderr) => {

            console.log("stdout:", stdout);
            console.log("stderr:", stderr);

            if (error) {
                console.error("Exec Error:", error);

                return res.status(500).json({
                    error: error.message,
                    stderr
                });
            }

            res.json({
                success: true
            });
        }
    );
});

app.listen(9000, () => {
    console.log(
        "Host monitoring service running"
    );
});
