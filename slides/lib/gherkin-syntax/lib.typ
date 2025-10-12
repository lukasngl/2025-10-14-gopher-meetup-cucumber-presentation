// Adds gherkin/cucumber to the syntaxes available for raw text
// Respectfully stolen from: https://codeberg.org/foxy/color-my-agda/src/branch/main/main.typ
#let cucumber-syntax(body) = context {
  // The syntaxes previously available in the current context
  let syntaxes-old = raw.syntaxes
  // The type of the variable storing the syntaxes previously available
  let syntaxes-old-type = type(syntaxes-old)
  // The syntaxes to be added
  let syntaxes-new = ("./gherkin-minimal.sublime-syntax",)
  // The syntaxes that will be available after the operation
  let syntaxes-merged = (
    (
      if syntaxes-old-type == str { (syntaxes-old,) } else if syntaxes-old-type
        == array { syntaxes-old } else {
        panic(
          "unmet assumption: raw.syntaxes' type is "
            + syntaxes-old-type
            + ", but should be string or array",
        )
      }
    )
      + syntaxes-new
  )
  set raw(syntaxes: syntaxes-merged)
  body
}
