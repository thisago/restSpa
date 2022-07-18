from std/strutils import join

import restSpa/db

template getFromDb*(
  table: type;
  blank: ref object;
  identifiers: openArray[string];
  vars: untyped
): untyped =
  let tableName = astToStr table
  var query: seq[string]
  for identifier in identifiers:
    query.add tableName & "." & identifier & " = ?"
  result = blank
  try:
    inDb: dbConn.select(
      result,
      query.join " or ",
      vars
    )
  except NotFoundError: discard
