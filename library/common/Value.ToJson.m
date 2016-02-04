/*
  -----------------------------------------------------------------------------
  GPLv3 | https://github.com/power-query/power-query-library
  -----------------------------------------------------------------------------
  Authors: Max Buyers
  Function: Value.ToJson
  Returns:  Minimized JSON-object
  Example:  below
  Depends:  Value.TypeToText, Value.ToText
  Comments:
  -----------------------------------------------------------------------------
*/

let Value.ToJson =
    (
      Val as any
    ) as text =>
    let
      Value.TypeToText = __("Value.TypeToText"),
      Value.ToText = __("Value.ToText"),
      Type = Value.TypeToText(Val),
      Sq = "#(2032,02DD,2034,02DD,2032)",
      Dq = "#(0022)",
      Quote     = (i as text) => Sq & i & Sq,
      Combine   = (i as list) => Text.Combine(i,","),
      Array     = (i as text) => "[" & i & "]",
      Object    = (i as text) => "{" & i & "}",
      Rules = [
        table   = Array(Combine(
          Table.TransformRows(Val, each @Value.ToJson(_)) )),
        record  = let
            Fields    = Record.FieldNames(Val),
            Values    = Record.FieldValues(Val),
            Transform = List.Transform(Fields,
              each Quote(_) & ":" &
              @Value.ToJson(Record.Field(Val, _)))
          in Object(Combine(Transform)),
        list    = Array(Combine(
          List.Transform(Val, each @Value.ToJson(_)))),
        text    = Quote(Val),
        number  = Value.ToText(Val),
        null    = "null",
        logical = Value.ToText(Val),
        date = Quote(Value.ToText(Val, "YYYY-MM-DD")),
        time = Quote(Value.ToText(Val, "hh:mm:ss.nnnnnnn")),
        datetime = Quote(Value.ToText(Val, "YYYY-MM-DDThh:mm:ss.nnnnnnn")),
        datetimezone = Quote(Value.ToText(Val, "YYYY-MM-DDThh:mm:ss.nnnZ")),
        duration = Quote(Value.ToText(Val, "PdDhHmM[:s]S")),
        type = Quote(Value.TypeToText(Val)),
        binary = Quote(Binary.ToText(Val, BinaryEncoding.Hex))
      ]
    in Text.Replace(Record.Field(Rules, Type), Sq, Dq)
in Value.ToJson

/* Example

Value.ToJson([
    array = {1, 2, 3},
    boolean = true,
    datetime = #datetime(2013,1,3,12,4,5),
    datetimezone = #datetimezone(2012, 7, 24, 14, 50, 52.9842245, -7, 0),
    null = null,
    number = 123,
    object = [
        a = "b",
        c = "d",
        e = "f"
    ],
    string = "Hello World"])

*/