# AzulCrawler

**Fetches flight information for a date range from Azul website**

## Installation

You need to have a chromedriver that is specific for your chrome browser version, you can get it [here](https://chromedriver.chromium.org/downloads).

Place the `chromdriver` executable in this folder.

Now, download all the dependencies:

```sh
$ mix deps.get
```

Now, in the terminal you can run the program with the following command:

```sh
$ mix flights
```

The program will ask some questions and fetch the data, you will see something like this:

```sh
Type the departure airport code (default: FLN):
> FLN

Type the arrival airport code (default: URG):
> URG

Type the start departure date in ISO 8601 format (YYYY-MM-DD) (default: 2022-10-23):
> 2022-10-23

Type the end departure date in ISO 8601 format (YYYY-MM-DD) (default: 2022-10-23):
> 2022-10-24

Is this a round-trip flight? [yN]: y

Fetching flights for FLN -> URG [≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡] 100%
Creating xlsx files         [≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡] 100%
Fetching flights for URG -> FLN [≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡] 100%
Creating xlsx files         [≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡] 100%
```

When the script is done, you will have some `.xsls` files in the same directory with the flight data.
