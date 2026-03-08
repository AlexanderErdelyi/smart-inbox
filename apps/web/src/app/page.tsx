const bullets = [
  'Connect Gmail via OAuth (first provider)',
  'Normalize messages through provider adapter contracts',
  'Classify and suggest actions asynchronously',
];

export default function HomePage() {
  return (
    <main className="container">
      <h1>Smart Inbox</h1>
      <p>Gmail-first implementation with multi-provider architecture from day one.</p>
      <ul>
        {bullets.map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>
    </main>
  );
}
