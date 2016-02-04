/*
  -----------------------------------------------------------------------------
  GPLv3 | https://github.com/power-query/power-query-library
  -----------------------------------------------------------------------------
  Authors: Max Buyers
  Function: Value.ToText
  Returns:  Value with normalized to string primitive values
  Example:  below
  Depends:  Value.TypeToText
  Comments:

  ------------------------------------------------------------------------
  Arguments:

  + Value
    required: yes
    type: any
    desc: primitive or structured value

  + format:
    required: no
    type: record or text
    desc: optional common or specified format for number/date/time values
    examples:
      [f = "YYYY-MM-DDThh:mm:ssZ"]
      [f = [
        datetime = "YYYY-MM-DDThh:mm:ss.nnnnnnn"
      , datetimezone = "YYYY-MM-DDThh:mm:ssZ"
      ]

  + culture:
    required: no
    type: text
    desc: optional culture for number/date/time values
    examples: [c = "ru-RU"]
    comments:
      + Use National Language Support (NLS) API Reference for culture codes:
        https://msdn.microsoft.com/en-us/goglobal/bb896001.aspx
  ------------------------------------------------------------------------
*/

let
    Value.ToText =
    (
      Value as any
      , optional format as any
      , optional culture as text
    ) as any => let
      format    = try format  as text otherwise try format as record otherwise null
    , culture   = try culture as text otherwise "en-US"
    , Recursion = (Value) => @Value.ToText(Value, format, culture)
    , Value.TypeToText = __("Value.TypeToText")
    //
    , Type  = Value.TypeToText(Value)
    , Rules = [
        null          = ""
      , logical       = Logical.ToText(Value)
      , number        = Number.ToText(Value,       try format[number]       as text otherwise try format as text otherwise null, culture)
      , time          = Time.ToText(Value,         try format[time]         as text otherwise try format as text otherwise null, culture)
      , date          = Date.ToText(Value,         try format[date]         as text otherwise try format as text otherwise null, culture)
      , datetime      = DateTime.ToText(Value,     try format[datetime]     as text otherwise try format as text otherwise null, culture)
      , datetimezone  = DateTimeZone.ToText(Value, try format[datetimezone] as text otherwise try format as text otherwise null, culture)
      , duration      = Duration.ToText(Value,     try format[duration]     as text otherwise try format as text otherwise null)
      , type          = "type"
      , text          = Value
      , list          = List.Transform(Value, each Recursion(_))
      , record        = let
          FieldNames  = Record.FieldNames(Value)
        , FieldValues = Record.FieldValues(Value)
        , Transformed = List.Transform(FieldValues, each Recursion(_))
        in Record.FromList(Transformed, FieldNames)
      , table         = Table.TransformColumns(Value, List.Transform(
          Table.ColumnNames(Value), each {_, each Recursion(_)}))
      , binary        = Binary.ToText(Value)
      ]
    in Record.Field(Rules, Type)

in Value.ToText

/*
  ------------------------------------------------------------------------
  Example
  ------------------------------------------------------------------------
  __("Value.ToText")(
      #table(
        type table [
          Null = null
        , Logical = logical
        , Number  = number
        , Time    = time
        , Date    = date
        , Datetime = datetime
        , Datetimezone = datetimezone
        , Duration = duration
        , Type = type
        , Text = text
        , List = list
        , Record = record
        , Table = table
        , Binary = binary
        ]
      , {
          {
            null
          , true
          , 1
          , #time(20,43,12)
          , #date(2015, 1, 1)
          , #datetime(2015, 1, 1, 21, 49, 18)
          , #datetimezone(2015, 1, 1, 21, 49, 18, 3, 0)
          , #duration(0, 0, 5, -30)
          , type {type}
          , "Hello World!"
          , {null, false, 2, #time(20,43,12), "Goodbye World!"}
          , [A = 1, B = "2"]
          , #table({"x", "x^2"}, {{1,1}, {2,4}, {3,9}})
          , #binary({0x00, 0x01, 0x02, 0x03})
          }
        , {
            null
          , false
          , 2
          , #time(12,55,1)
          , #date(2035, 1, 1)
          , #datetime(2035, 5, 5, 15, 55, 55)
          , #datetimezone(2015, 1, 1, 21, 49, 18, 3, 0)
          , #duration(0, 0, 5, -30)
          , type {type}
          , "Hello World!"
          , {null, false, 2, #time(20,43,12), "Goodbye World!"}
          , [A = 1, B = "2"]
          , #table({"x", "x^2"}, {{1,1}, {2,4}, {3,9}})
          , #binary({0x00, 0x01, 0x02, 0x03})
          }
        }
      ))
  ------------------------------------------------------------------------
*/