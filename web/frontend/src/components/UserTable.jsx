function UserTable({
  usersAdded,
  usersDeleted
}) {
  return (
    <div className="section-card">

      <h2>User Monitoring</h2>

      <table>

        <thead>
          <tr>
            <th>Users Added</th>
            <th>Users Deleted</th>
          </tr>
        </thead>

        <tbody>

          {Array.from({
            length: Math.max(
              usersAdded.length,
              usersDeleted.length
            )
          }).map((_, index) => (

            <tr key={index}>
              <td>{usersAdded[index] || "-"}</td>
              <td>{usersDeleted[index] || "-"}</td>
            </tr>

          ))}

        </tbody>

      </table>

    </div>
  );
}

export default UserTable;