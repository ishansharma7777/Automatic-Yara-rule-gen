# Stock Data Processing - Monthly Aggregation & Technical Indicators

This project processes daily stock price data and converts it to monthly aggregates with technical indicators (SMA and EMA).

## Overview

The script processes a 2-year historical dataset containing daily stock prices for 10 unique tickers and:
1. Resamples data from daily to monthly frequency
2. Calculates monthly aggregates (Open, High, Low, Close)
3. Computes technical indicators (SMA 10, SMA 20, EMA 10, EMA 20)
4. Partitions results into separate CSV files per ticker

## Dataset

The input dataset contains daily stock data for the following 10 tickers:
- AAPL, AMD, AMZN, AVGO, CSCO, MSFT, NFLX, PEP, TMUS, TSLA

**Dataset Link:** https://github.com/sandeep-tt/tt-intern-dataset

## Installation

1. Install required dependencies:
```bash
pip install -r requirements.txt
```

## Usage

1. Run the processing script:
```bash
python stock_data_processor.py
```

2. Output files will be generated in the `output/` directory with naming convention: `result_{SYMBOL}.csv`

## Output Format

Each output CSV file contains the following columns:
- `date`: Month-end date (YYYY-MM-DD format)
- `Open`: First trading day's open price of the month
- `High`: Maximum high price during the month
- `Low`: Minimum low price during the month
- `Close`: Last trading day's close price of the month
- `AdjClose`: Last trading day's adjusted close price
- `Volume`: Sum of volume for the month
- `SMA_10`: 10-period Simple Moving Average
- `SMA_20`: 20-period Simple Moving Average
- `EMA_10`: 10-period Exponential Moving Average
- `EMA_20`: 20-period Exponential Moving Average

Each file contains exactly 24 rows (representing 24 months in the 2-year period).

## Implementation Details

### Monthly Aggregation Logic

- **Open**: The price at the first trading day of the month (using `first()` aggregation)
- **Close**: The price at the last trading day of the month (using `last()` aggregation)
- **High**: The maximum price reached during the month (using `max()` aggregation)
- **Low**: The minimum price reached during the month (using `min()` aggregation)

### Technical Indicators

#### Simple Moving Average (SMA)
Formula: `SMA = Sum of closing prices (over N periods) / N`

#### Exponential Moving Average (EMA)
- Multiplier = 2 / (Number of Periods + 1)
- EMA = (Current Price - Previous Day's EMA) × Multiplier + Previous Day's EMA
- First EMA uses SMA as the initial value

The implementation uses Pandas' built-in functions:
- `rolling().mean()` for SMA
- `ewm(span=window, adjust=False).mean()` for EMA

## Code Structure

The code is modular with separate functions for:
- **Data Loading**: `load_data()` - Loads and preprocesses the CSV file
- **Monthly Aggregation**: `calculate_monthly_aggregates()` - Resamples daily to monthly data
- **Technical Indicators**: 
  - `calculate_sma()` - Calculates Simple Moving Average
  - `calculate_ema()` - Calculates Exponential Moving Average
  - `add_technical_indicators()` - Adds all indicators to the dataframe
- **File Writing**: `partition_and_save()` - Partitions data by ticker and saves to CSV files

## Assumptions

1. **Input File Format**: The input CSV file is expected to be named `stock_data.csv` and placed in the project root directory. The file should contain columns: `date`, `volume`, `open`, `high`, `low`, `close`, `adjclose`, `ticker`.

2. **Date Format**: The script assumes dates in the input CSV can be parsed by `pd.to_datetime()`. Common formats like YYYY-MM-DD, MM/DD/YYYY, etc. should work.

3. **Data Completeness**: The script assumes there is at least one trading day per month for each ticker. If a month has no data, it will still be included in the output but with NaN values for aggregates.

4. **Monthly Resampling**: Uses month-end ('M') frequency for resampling. The date column in output represents the last day of each month.

5. **Technical Indicators**: 
   - SMA and EMA are calculated based on monthly closing prices
   - For periods where there are fewer than N data points, the indicators use available data (min_periods=1 for SMA)
   - EMA calculation uses Pandas' exponential weighted moving average with `adjust=False` to match the standard EMA formula

6. **Output Directory**: Output files are saved to an `output/` directory, which is created automatically if it doesn't exist.

7. **Data Ordering**: Output files are sorted chronologically by date to ensure proper time series ordering.

8. **Missing Data**: If there are gaps in the data, the script will still process available data. Missing values in technical indicators will appear as NaN for periods where insufficient data is available.


