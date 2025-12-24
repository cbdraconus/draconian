import './styles.css';

const App = () => {
  return (
    <div className="app">
      <header className="app__header">
        <h1>Responder Schedule</h1>
        <p>Secure scheduling for 8/10/12 hour shifts, assignments, and grants.</p>
      </header>
      <main className="app__grid">
        <section className="card">
          <h2>My Schedule</h2>
          <p>View your assigned shifts and upcoming coverage.</p>
        </section>
        <section className="card">
          <h2>Department Schedule</h2>
          <p>See staffing across units, ranks, and special assignments.</p>
        </section>
        <section className="card">
          <h2>Admin Tools</h2>
          <p>Manage ranks, assignments, grants, and shift templates.</p>
        </section>
        <section className="card">
          <h2>Calendar Sync</h2>
          <p>Connect Outlook, Google, or Apple Calendar.</p>
        </section>
      </main>
    </div>
  );
};

export default App;
