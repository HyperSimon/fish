function precommit
    npm run lint-fix;
    npm run lint;
    jest --coverage $argv;
end
