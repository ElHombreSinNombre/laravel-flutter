## Newman

Verify that you have installed **[Node](https://nodejs.org/es/)**.

Install **[Newman](https://www.npmjs.com/package/newman)** and **[Newman Reporter HTMLExtra](https://www.npmjs.com/package/newman-reporter-htmlextra)** then create new report.

Run in _CMD_

    npm i newman newman-reporter-htmlextra
    newman run collection.json -e environment.json -r htmlextra
