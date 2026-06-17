import nodemailer from "nodemailer";

const sendAlertEmail = async (filePath) => {
    const transporter = nodemailer.createTransport({
        service: "gmail",

        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS,
        },
    });

    await transporter.sendMail({
        from: process.env.EMAIL_USER,

        to: process.env.ALERT_EMAIL,

        subject: "Linux Monitoring Alert",

        text: "Critical monitoring alert detected.",

        attachments: [
            {
                filename: "data.txt",
                path: filePath,
            },
        ],
    });
};

export { sendAlertEmail };
