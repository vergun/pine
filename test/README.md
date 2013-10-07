# Pine tests

#### Unit Tests
Unit tests use coffee coverage, mocha, and coffee-script:

    npm install -g coffee-script
    npm install -g mocha
    npm install -g chai
    npm install -g coffee-coverage
    
Then from the root directory run:

    npm test

#### Integration Tests
Integration tests use functions from the development version of CasperJS. To install with homebrew:

    brew install casperjs --devel

Integration tests from the root directory type in console:

    casperjs test test/integration/:filename

