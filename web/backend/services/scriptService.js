import { exec } from "child_process";

const runMonitoringScript = () => {
    return new Promise((resolve, reject) => {
        exec(
            `echo "${process.env.SUDO_PASSWORD}" | sudo -S bash monitoring/monitoring_script.sh`,
            (error, stdout, stderr) => {
                
                if (error) {
                    console.log("ERROR:", error);
                    reject(error);
                    return;
                }
                
                resolve(stdout);
            }
        );
    });
};

export { runMonitoringScript };