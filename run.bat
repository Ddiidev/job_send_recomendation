@echo off

set "debug=%~1"

if "%debug%" NEQ "" (
    set "debug=-d %debug%"
)

v -no-skip-unused %debug% -d trace_orm -d trace_orm_query watch --before "cls" run .