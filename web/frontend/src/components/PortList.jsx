function PortList({ ports }) {
  return (
    <div className="section-card">

      <h2>Unauthorized Ports</h2>

      <div className="port-container">

        {ports.length > 0 ? (

          ports.map((port, index) => (

            <span
              key={index}
              className="port-badge"
            >
              {port}
            </span>

          ))

        ) : (

          <p>No Unauthorized Ports</p>

        )}

      </div>

    </div>
  );
}

export default PortList;