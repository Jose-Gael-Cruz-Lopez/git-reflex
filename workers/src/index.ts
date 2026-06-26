// Git Reflex Workers API entrypoint (structure-first scaffold).
// Route handlers are scaffolded per-issue under workers/src/ and wired here.
export default {
  async fetch(_request: Request): Promise<Response> {
    // TODO(#48): router, JWT verify, rate limit
    return new Response(JSON.stringify({ ok: true, service: "git-reflex-api" }), {
      headers: { "content-type": "application/json" },
    });
  },
};
