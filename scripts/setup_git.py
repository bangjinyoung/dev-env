from pathlib import Path
import subprocess
import sys

def run_git_config(args: list[str]) -> str:
    result = subprocess.run(
        ["git", "config", "--global", *args],
        text=True,
        capture_output=True,
    )

    if result.returncode != 0:
        # git config --get-all 같은 명령은 값이 없으면 실패할 수 있으므로
        # 호출부에서 필요한 경우만 예외 처리한다.
        return ""

    return result.stdout.strip()


def run_git_config_checked(args: list[str]) -> None:
    result = subprocess.run(
        ["git", "config", "--global", *args],
        text=True,
        capture_output=True,
    )

    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())

def to_git_path(path: Path) -> str:
    # Windows에서도 Git이 안정적으로 인식하도록 / 구분자로 변환
    return path.resolve().as_posix()

def main() -> int:
    dev_env_root = Path(__file__).resolve().parents[1]

    git_config_path = dev_env_root / "git" / ".gitconfig"
    commit_template_path = (
        dev_env_root
        / "git"
        / "git-commit-template"
        / "git-commit-template.txt"
    )

    if not git_config_path.exists():
        print(f"Git config not found: {git_config_path}")
        return 1

    if not commit_template_path.exists():
        print(f"Commit template not found: {commit_template_path}")
        return 1

    git_config_for_git = to_git_path(git_config_path)
    commit_template_for_git = to_git_path(commit_template_path)

    # 1. dev-env의 공통 git config 등록
    current_includes = run_git_config(["--get-all", "include.path"])
    include_paths = current_includes.splitlines() if current_includes else []

    if git_config_for_git not in include_paths:
        run_git_config_checked(["--add", "include.path", git_config_for_git])
        print(f"Added include.path: {git_config_for_git}")
    else:
        print(f"include.path already exists: {git_config_for_git}")

    # 2. commit message template 등록
    run_git_config_checked(["commit.template", commit_template_for_git])
    print(f"Set commit.template: {commit_template_for_git}")

    print()
    print("Current Git config:")
    subprocess.run(["git", "config", "--global", "--get-all", "include.path"])
    subprocess.run(["git", "config", "--global", "--get", "commit.template"])

    return 0


if __name__ == "__main__":
    sys.exit(main())