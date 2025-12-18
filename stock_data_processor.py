import pandas as pd
import os


def load_data(file_path: str) -> pd.DataFrame:
    df = pd.read_csv(file_path)
    df['date'] = pd.to_datetime(df['date'])
    df = df.sort_values(['ticker', 'date'])
    return df


def calculate_monthly_aggregates(df: pd.DataFrame) -> pd.DataFrame:
    # Set date as index for resampling
    df_indexed = df.set_index('date')
    
    # Group by ticker and resample to monthly frequency
    monthly_data = df_indexed.groupby('ticker').resample('ME').agg({
        'open': 'first',      # First trading day's open
        'high': 'max',        # Maximum high during the month
        'low': 'min',         # Minimum low during the month
        'close': 'last',      # Last trading day's close
        'adjclose': 'last',   # Last trading day's adjusted close
        'volume': 'sum'       # Sum of volume for the month
    }).reset_index()
    
    # Rename columns to match expected output
    monthly_data = monthly_data.rename(columns={
        'date': 'date',
        'open': 'Open',
        'high': 'High',
        'low': 'Low',
        'close': 'Close',
        'adjclose': 'AdjClose',
        'volume': 'Volume'
    })
    
    return monthly_data


def calculate_sma(prices: pd.Series, window: int) -> pd.Series:
    return prices.rolling(window=window, min_periods=1).mean()


def calculate_ema(prices: pd.Series, window: int) -> pd.Series:
    return prices.ewm(span=window, adjust=False).mean()


def add_technical_indicators(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    
    # Group by ticker to calculate indicators per stock
    df['SMA_10'] = df.groupby('ticker')['Close'].transform(
        lambda x: calculate_sma(x, 10)
    )
    df['SMA_20'] = df.groupby('ticker')['Close'].transform(
        lambda x: calculate_sma(x, 20)
    )
    df['EMA_10'] = df.groupby('ticker')['Close'].transform(
        lambda x: calculate_ema(x, 10)
    )
    df['EMA_20'] = df.groupby('ticker')['Close'].transform(
        lambda x: calculate_ema(x, 20)
    )
    
    return df


def partition_and_save(df: pd.DataFrame, output_dir: str = 'output') -> None:
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Get unique tickers
    tickers = df['ticker'].unique()
    
    # Select columns for output (excluding ticker column)
    output_columns = ['date', 'Open', 'High', 'Low', 'Close', 'AdjClose', 
                      'Volume', 'SMA_10', 'SMA_20', 'EMA_10', 'EMA_20']
    
    # Partition and save each ticker's data
    for ticker in tickers:
        ticker_data = df[df['ticker'] == ticker].copy()
        
        # Select only the required columns
        ticker_data = ticker_data[output_columns]
        
        # Sort by date to ensure chronological order
        ticker_data = ticker_data.sort_values('date')
        
        # Format date column for output
        ticker_data['date'] = ticker_data['date'].dt.strftime('%Y-%m-%d')
        
        # Save to CSV
        output_file = os.path.join(output_dir, f'result_{ticker}.csv')
        ticker_data.to_csv(output_file, index=False)
        
        print(f"Saved {len(ticker_data)} rows to {output_file}")


def process_stock_data(input_file: str, output_dir: str = 'output') -> None:
    print("Loading data...")
    df = load_data(input_file)
    print(f"Loaded {len(df)} daily records for {df['ticker'].nunique()} tickers")
    
    print("Calculating monthly aggregates...")
    monthly_df = calculate_monthly_aggregates(df)
    print(f"Generated {len(monthly_df)} monthly records")
    
    print("Calculating technical indicators...")
    monthly_df = add_technical_indicators(monthly_df)
    
    print("Partitioning and saving results...")
    partition_and_save(monthly_df, output_dir)
    
    print("Processing complete!")


if __name__ == "__main__":
    # Default input file name (can be changed)
    input_file = "stock_data.csv"
    
    # Check if file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        print("Please ensure the CSV file is in the current directory.")
        print("You can download it from: https://github.com/sandeep-tt/tt-intern-dataset")
    else:
        process_stock_data(input_file)

