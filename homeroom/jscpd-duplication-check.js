#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");

const reportPath = process.argv[2];
const stagedFiles = new Set(process.argv.slice(3).map((f) => path.resolve(f)));

if (!reportPath || !fs.existsSync(reportPath)) {
  // No report = no duplication
  process.exit(0);
}

const report = JSON.parse(fs.readFileSync(reportPath, "utf8"));
const duplicates = report.duplicates || [];

const hits = duplicates.filter((d) => {
  const first = path.resolve(d.firstFile?.name || "");
  const second = path.resolve(d.secondFile?.name || "");
  return stagedFiles.has(first) || stagedFiles.has(second);
});

if (hits.length === 0) {
  process.exit(0);
}

console.log("DUPLICATION DETECTED in staged files:\n");

hits.forEach((h, i) => {
  const f1 = h.firstFile?.name || "unknown";
  const f2 = h.secondFile?.name || "unknown";
  const l1 = h.firstFile?.startLoc?.line || "?";
  const l2 = h.secondFile?.startLoc?.line || "?";
  const lines = h.lines || "?";

  console.log(`  ${i + 1}. ${f1}:${l1} <-> ${f2}:${l2} (${lines} lines)`);

  if (h.fragment) {
    const preview = h.fragment.split("\n").slice(0, 8).join("\n");
    console.log("     ---");
    preview.split("\n").forEach((line) => console.log(`     ${line}`));
    if (h.fragment.split("\n").length > 8) console.log("     ...");
    console.log("     ---");
  }
  console.log();
});

console.log(`Found ${hits.length} duplicate(s) involving staged files.\n`);

// Instructions for both humans and LLMs
console.log("ACTION REQUIRED:");
console.log("  - Review the duplicated code fragments above.");
console.log("  - Extract shared logic into a reusable helper, module, or base class.");
console.log("  - If duplication is intentional, add a jscpd:ignore comment to suppress.");
console.log();
console.log("LLM INSTRUCTIONS:");
console.log("  If you are an AI agent reading this output:");
console.log("  1. Show the user both duplicate locations with file:line references.");
console.log("  2. Propose a unified extraction (shared method, module, or concern).");
console.log("  3. Present at least two options: extract to shared location vs inline with jscpd:ignore.");
console.log("  4. Do NOT silently suppress this warning.");

process.exit(1);
