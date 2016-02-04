/*
  -----------------------------------------------------------------------------
  MIT License | https://github.com/power-query/power-query-library
  -----------------------------------------------------------------------------
  Authors: Max Buyers
  Function: Value.TypeToText
  Returns:  The primary value type name as string
  Example:  Value.TypeToText({1,2,3}) => "list"
  Depends:  none
  Comments: Inspired by tycho01 https://github.com/tycho01/pquery
  -----------------------------------------------------------------------------
*/

(Value as any) as text =>
let

  types = [
    null         = type null
  , logical      = type logical
  , number       = type number
  , time         = type time
  , date         = type date
  , datetime     = type datetime
  , datetimezone = type datetimezone
  , duration     = type duration
  , text         = type text
  , type         = type type
  , list         = type list
  , record       = type record
  , table        = type table
  , function     = type function
  , binary       = type binary
  , anynonnull   = type anynonnull
  ]
, Rules = List.Transform(Record.FieldNames(types), each {(x)=>Value.Is(x, Record.Field(types, _)), _})

in List.First(List.Select(Rules, each _{0}(Value))){1}