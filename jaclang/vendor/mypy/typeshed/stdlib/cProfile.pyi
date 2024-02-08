from _typeshed import StrOrBytesPath, Unused
from collections.abc import Callable
from types import CodeType
from typing import Any, TypeVar
from typing_extensions import ParamSpec, Self, TypeAlias

__all__ = ["run", "runctx", "Profile"]

def run(statement: str, filename: str | None = None, sort: str | int = -1) -> None: ...
def runctx(
    statement: str,
    globals: dict[str, Any],
    locals: dict[str, Any],
    filename: str | None = None,
    sort: str | int = -1,
) -> None: ...

_T = TypeVar("_T")
_P = ParamSpec("_P")
_Label: TypeAlias = tuple[str, int, str]

class Profile:
    stats: dict[
        _Label, tuple[int, int, int, int, dict[_Label, tuple[int, int, int, int]]]
    ]  # undocumented
    def __init__(
        self,
        timer: Callable[[], float] = ...,
        timeunit: float = ...,
        subcalls: bool = ...,
        builtins: bool = ...,
    ) -> None: ...
    def enable(self) -> None: ...
    def disable(self) -> None: ...
    def print_stats(self, sort: str | int = -1) -> None: ...
    def dump_stats(self, file: StrOrBytesPath) -> None: ...
    def create_stats(self) -> None: ...
    def snapshot_stats(self) -> None: ...
    def run(self, cmd: str) -> Self: ...
    def runctx(
        self, cmd: str, globals: dict[str, Any], locals: dict[str, Any]
    ) -> Self: ...
    def runcall(
        self, __func: Callable[_P, _T], *args: _P.args, **kw: _P.kwargs
    ) -> _T: ...
    def __enter__(self) -> Self: ...
    def __exit__(self, *exc_info: Unused) -> None: ...

def label(code: str | CodeType) -> _Label: ...  # undocumented
