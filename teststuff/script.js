/**
  * @param {string} fmt 
  * @returns void
  */
function callMe(fmt) {
  console.log(`${fmt} just said.`);
}

test("Script", () => {
  assert.strictEqual(1 + 2, 4)
})

callMe("Hei")
