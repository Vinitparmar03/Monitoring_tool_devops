function GroupTable({
  groupsAdded,
  groupsDeleted
}) {
  return (
    <div className="section-card">

      <h2>Group Monitoring</h2>

      <table>

        <thead>
          <tr>
            <th>Groups Added</th>
            <th>Groups Deleted</th>
          </tr>
        </thead>

        <tbody>

          {Array.from({
            length: Math.max(
              groupsAdded.length,
              groupsDeleted.length
            )
          }).map((_, index) => (

            <tr key={index}>
              <td>{groupsAdded[index] || "-"}</td>
              <td>{groupsDeleted[index] || "-"}</td>
            </tr>

          ))}

        </tbody>

      </table>

    </div>
  );
}

export default GroupTable;