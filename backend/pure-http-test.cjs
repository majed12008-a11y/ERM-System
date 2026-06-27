const http = require("http");
const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ status: "ok" }));
});
server.listen(3000, () => {
  console.log("Server listening on 3000, address:", server.address());
  const client = http.get("http://127.0.0.1:3000/", (res) => {
    let data = "";
    res.on("data", c => data += c);
    res.on("end", () => { console.log("SELF-TEST:", data); process.exit(0); });
  });
  client.on("error", (e) => { console.log("CLIENT ERROR:", e.code, e.message); process.exit(1); });
});
server.on("error", (e) => { console.log("SERVER ERROR:", e.code, e.message); process.exit(1); });
