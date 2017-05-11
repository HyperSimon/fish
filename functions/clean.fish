function clean
    watchman watch-del-all;
    rm -rf node_modules;
    yarn install;
    npm start --reset-cache;
end
