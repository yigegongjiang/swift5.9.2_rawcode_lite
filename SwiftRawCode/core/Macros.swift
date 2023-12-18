#if $Macros && hasAttribute(attached)
@freestanding(expression)
public macro externalMacro<T>(module: String, type: String) -> T =
  Builtin.ExternalMacro
@freestanding(expression)
public macro fileID<T: ExpressibleByStringLiteral>() -> T =
  Builtin.FileIDMacro
@freestanding(expression)
public macro filePath<T: ExpressibleByStringLiteral>() -> T =
  Builtin.FilePathMacro
@freestanding(expression)
public macro file<T: ExpressibleByStringLiteral>() -> T =
  Builtin.FileMacro
@freestanding(expression)
public macro function<T: ExpressibleByStringLiteral>() -> T =
  Builtin.FunctionMacro
@freestanding(expression)
public macro line<T: ExpressibleByIntegerLiteral>() -> T =
  Builtin.LineMacro
@freestanding(expression)
public macro column<T: ExpressibleByIntegerLiteral>() -> T =
  Builtin.ColumnMacro
@freestanding(expression)
public macro dsohandle() -> UnsafeRawPointer = Builtin.DSOHandleMacro
@freestanding(declaration)
public macro warning(_ message: String) = Builtin.WarningMacro
@freestanding(declaration)
public macro error(_ message: String) = Builtin.ErrorMacro
#endif
