import axios from "axios";

const API = import.meta.env.VITE_BACKEND;

export const getMonitoringData = async () => {
  const response = await axios.get(API);
  return response.data;
};

export const refreshMonitoringData =
  async () => {
    const response =
      await axios.post(`${API}/refresh`);

    return response.data;
  };