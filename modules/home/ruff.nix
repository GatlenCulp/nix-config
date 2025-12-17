{
  # NOTE: In my opinion:

  # FORMATTING / FIXING
  # 1. Basically everything should be selected for auto-fixes/formats.
  # 2. Only stylistic preferences should be ignored across the board or things that are actually necessary for your code
  # 3. Would be nice to have the things that were formatted/fixed be printed so you know how you change what you write

  # LINTING AS CI/CD
  # 1. For CI/CD linting and "passing tests", you may want to select/ignore certain things that can't automatically be fixed / formatted(?)

  # LINTING AS EDITOR RECOMMENDATION
  # 1. IMO, things that can be formatted / autofixed should be ignorable (actually with autoformat/fix on save, probably better to know which things were formatted/fixed to improve your writing style and best practices)
  # 2. Ignore trivial unfixable things. E.g. a line comment a bit too long

  # ---------
  # Ignored prompt
  #   Break this file up into some profiles I can combine to use for different projects.

  # 1. Base -- E.g. I always want to select all. I always want to treat "loguru.logger" as a logger-object. I always want quote-style double, indent-style space
  # 2.

  # TODO: Would also be nice to have some kind of PROFILE to distinguish code I'M writing from code that others have written(?)

  # TODO: Add banned imports (e.g. logging, matplotlib, etc. Recommend replacements instead.)

  # Dangerous
  unsafe-fixes = true;

  # Maximum line length for code formatting
  line-length = 99;

  format = {
    # Use double quotes for strings
    quote-style = "double";

    # Use spaces for indentation (not tabs)
    indent-style = "space";
  };

  lint = {
    # Logger objects for flake8-logging
    logger-objects = [
      "loguru.logger"
      "src.config.logger" # Package logger
    ];
    select = [ "ALL" ];
    ignore = [
      "B018"
      # useless-expression: Found useless expression
      # Disabled to allow intentional expressions in notebooks and REPL-style code

      "COM812"
      # missing-trailing-comma: Trailing comma missing
      # Disabled due to conflict with formatter and ISC001

      "D100"
      # undocumented-public-module: Missing docstring in public module
      # Disabled to reduce docstring requirements for simple modules

      "D103"
      # undocumented-public-function: Missing docstring in public function
      # Disabled to allow simple functions without docstrings

      "D105"
      # undocumented-magic-method: Missing docstring in magic method
      # Disabled as magic methods are typically self-explanatory

      "D107"
      # undocumented-public-init: Missing docstring in `__init__`
      # Disabled as __init__ docstrings are often redundant with class docstrings

      "D205"
      # blank-line-after-summary: 1 blank line required between summary line and description
      # Disabled to allow more flexible docstring formatting

      "D415"
      # ends-in-punctuation: First line should end with a period, question mark, or exclamation point
      # Disabled for less strict docstring requirements

      "E731"
      # lambda-assignment: Do not assign a lambda expression, use a def
      # Disabled to allow lambda assignments for simple functions

      "EM101"
      # raw-string-in-exception: Exception must not use a string literal, assign to variable first
      # Disabled to allow inline exception messages

      "ERA001"
      # commented-out-code: Found commented-out code
      # Disabled to allow keeping reference code in comments

      "FBT001"
      # boolean-type-hint-positional-argument: Boolean-typed positional argument in function definition
      # Disabled to allow boolean positional arguments

      "FBT002"
      # boolean-default-value-positional-argument: Boolean default positional argument in function definition
      # Disabled to allow boolean default positional arguments

      "INP001"
      # implicit-namespace-package: File is part of an implicit namespace package
      # Disabled to allow namespace packages without __init__.py

      "ISC001"
      # single-line-implicit-string-concatenation: Implicitly concatenated string literals on one line
      # Disabled due to conflict with formatter and COM812

      "RET504"
      # unnecessary-assign: Unnecessary assignment before `return` statement
      # Disabled to allow explicit variable names before return for clarity

      "S101"
      # assert: Use of `assert` detected
      # Disabled to allow assert statements in non-production code

      "T201"
      # print: `print` found
      # Disabled to allow print statements for debugging and simple scripts

      "TD002"
      # missing-todo-author: Missing author in TODO
      # Disabled to allow TODOs without author attribution

      "TD003"
      # missing-todo-link: Missing issue link on the line following this TODO
      # Disabled to allow TODOs without issue tracking links

      "TRY003"
      # raise-vanilla-args: Avoid specifying long messages outside the exception class
      # Disabled to allow inline exception messages

      "UP007"
      # non-pep604-annotation: Use `X | Y` for type annotations
      # Disabled to allow Union[] syntax for backward compatibility

      "UP035"
      # deprecated-import: Import from `collections.abc` instead
      # Disabled to allow imports from collections for backward compatibility

      "W293"
      # blank-line-with-whitespace: Blank line contains whitespace
      # Disabled as this is typically handled by formatters
    ];

    # Allow automatic fixing for all rules
    fixable = [
      "ALL"
    ];

    # Do not automatically fix any rules
    unfixable = [ ];

    # McCabe complexity checker settings
    mccabe = {
      # Maximum allowed complexity for functions
      max-complexity = 10;
    };

    # pycodestyle settings
    pycodestyle = {
      # Maximum line length for docstrings and comments
      max-doc-length = 99;
    };

    # pydocstyle settings
    pydocstyle = {
      # Use Google-style docstring convention
      convention = "google";
    };

    # isort import sorting settings
    isort = {
      # Force imports to be sorted within their sections
      force-sort-within-sections = true;
    };

    # Per-file rule overrides
    per-file-ignores = {
      # __init__.py files: allow unused imports
      "**/__init__.py" = [
        "F401"
        # unused-import: Module imported but unused
        # Disabled to allow re-exporting imports from __init__.py
      ];

      # Jupyter notebooks: relax many rules for exploratory coding
      "**/*.ipynb" = [
        "D103"
        # undocumented-public-function: Missing docstring in public function
        # Disabled to allow exploration without documentation overhead

        "D105"
        # undocumented-magic-method: Missing docstring in magic method
        # Disabled as magic methods are typically self-explanatory

        "D107"
        # undocumented-public-init: Missing docstring in `__init__`
        # Disabled as __init__ docstrings are often redundant

        "D205"
        # blank-line-after-summary: 1 blank line required between summary line and description
        # Disabled for flexible notebook documentation

        "D415"
        # ends-in-punctuation: First line should end with a period, question mark, or exclamation point
        # Disabled for less strict notebook documentation

        "E731"
        # lambda-assignment: Do not assign a lambda expression, use a def
        # Disabled for quick prototyping in notebooks

        "EM101"
        # raw-string-in-exception: Exception must not use a string literal, assign to variable first
        # Disabled for rapid experimentation

        "S101"
        # assert: Use of `assert` detected
        # Disabled as notebooks are not production code

        "T201"
        # print: `print` found
        # Disabled as print is essential for notebook output

        "TD002"
        # missing-todo-author: Missing author in TODO
        # Disabled for personal notebook TODOs

        "TD003"
        # missing-todo-link: Missing issue link on the line following this TODO
        # Disabled for personal notebook TODOs

        "UP007"
        # non-pep604-annotation: Use `X | Y` for type annotations
        # Disabled for backward compatibility

        "UP035"
        # deprecated-import: Import from `collections.abc` instead
        # Disabled for backward compatibility
      ];

      # Test files: allow testing-specific patterns
      "tests/**/*.py" = [
        "ANN001"
        # missing-type-function-argument: Missing type annotation for function argument
        # Disabled for cleaner test code

        "ANN201"
        # missing-return-type-undocumented-public-function: Missing return type annotation for public function
        # Disabled for cleaner test code

        "ARG001"
        # unused-function-argument: Unused function argument
        # Disabled to allow pytest fixtures as unused arguments

        "FBT001"
        # boolean-type-hint-positional-argument: Boolean-typed positional argument in function definition
        # Disabled to allow boolean test parameters

        "PLR2004"
        # magic-value-comparison: Magic value used in comparison
        # Disabled as test assertions often use literal values

        "RET503"
        # implicit-return: Missing explicit `return` at the end of function able to return non-`None` value
        # Disabled for test helper functions

        "S101"
        # assert: Use of `assert` detected
        # Disabled as assert is the standard for pytest

        "S311"
        # suspicious-non-cryptographic-random-usage: Standard pseudo-random generators are not suitable for cryptographic purposes
        # Disabled as tests don't require cryptographic randomness
      ];
    };
  };
}
