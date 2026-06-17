import { useEffect, useState } from "react";

import MetricCard from "../components/MetricCard";
import UserTable from "../components/UserTable";
import GroupTable from "../components/GroupTable";
import PortList from "../components/PortList";

import {
  getMonitoringData,
  refreshMonitoringData
} from "../services/monitoringApi";

function Dashboard() {

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  const loadData = async () => {

    try {

      const response =
        await getMonitoringData();

      setData(response);

    } catch (error) {

      console.log(error);

    } finally {

      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const handleRefresh = async () => {

    setLoading(true);

    const response =
      await refreshMonitoringData();

    setData(response);

    setLoading(false);
  };

  if (loading)
    return (
      <div className="loading">
        Loading Dashboard...
      </div>
    );

  return (

    <div className="dashboard">

      <div className="dashboard-header">

        <div>
          <h1>
            Linux Monitoring Dashboard
          </h1>

          <p>
            Real-Time System Monitoring
          </p>
        </div>

        <button
          className="refresh-btn"
          onClick={handleRefresh}
        >
          Refresh
        </button>

      </div>

      <div className="info-card">

        <div>
          <span>Hostname</span>
          <h3>{data.hostname}</h3>
        </div>

        <div>
          <span>Last Updated</span>
          <h3>{data.timestamp}</h3>
        </div>

      </div>

      <div className="grid">

        <MetricCard
          title="CPU Usage"
          value={`${data.system_metrics.cpu_usage_percent}%`}
        />

        <MetricCard
          title="Memory Usage"
          value={`${data.system_metrics.memory_usage_percent}%`}
        />

        <MetricCard
          title="Disk Usage"
          value={`${data.system_metrics.disk_usage_percent}%`}
        />

        <MetricCard
          title="Load Average"
          value={data.system_metrics.load_average}
        />

        <MetricCard
          title="CPU Cores"
          value={data.system_metrics.cpu_cores}
        />

        <MetricCard
          title="SSH Status"
          value={data.ssh_monitoring.status}
        />

        <MetricCard
          title="Failed Attempts"
          value={data.ssh_monitoring.failed_attempts}
        />

      </div>

      <UserTable
        usersAdded={
          data.user_monitoring.users_added
        }
        usersDeleted={
          data.user_monitoring.users_deleted
        }
      />

      <GroupTable
        groupsAdded={
          data.group_monitoring.groups_added
        }
        groupsDeleted={
          data.group_monitoring.groups_deleted
        }
      />

      <PortList
        ports={
          data.port_monitoring
            .unauthorized_ports
        }
      />

    </div>
  );
}

export default Dashboard;