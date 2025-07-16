# Task 5

**Model diagram:** [Data Assistant.pdf](https://github.com/Romano-arist/wg/blob/main/task%205/Data%20Assistant.pdf) ([Miro](https://miro.com/welcomeonboard/TWIrOXhmT3ZvWkVEZCtSS1FSNkh0b2dJM0s3OXF6cG5VeC9NTVJPMUdFb0FIUFBQRWdkb1A3NUorcnU0b1d1MGRBWi84KzBBRlZHQkhjUmhERXdHTGozaTlTYnZ4cHFkdnoxR0ltWlpFdWFqQ1ZaWFUwQS83c3d0QnhJL0dXb3JyVmtkMG5hNDA3dVlncnBvRVB2ZXBnPT0hdjE=?share_link_id=752462169873)).  
*Note: For readability, please download and zoom in on the PDF or use the Miro link provided.*

## Data Pipeline
- **Client:** Raw battle results are streamed from the client and stored in its OLTP database.
- **Kafka:** Data from OLTP databases is transferred to Kafka.
- **Flink:** Consumes battle events from Kafka and performs real-time aggregations (e.g., player-vehicle stats, equipment, boosters). 
Updates Redis aggregates and writes to the Data Warehouse (DWH). 
- **DWH (Data Warehouse):** Stores historical and aggregated data.
- **Airflow / Dagster / Airbyte:** Moves processed aggregates to Clickhouse cluster.
- **Redis updater service**: Updates Redis with the aggregates from Clickhouse.
- **Redis:** Stores stats for robust client access.

## Functional Flow

1. **Battle finished:** Raw battle data is sent from the client to the OLTP database.
2. **Data transport:** Data is sent to Kafka, then processed through Flink. Flink aggregates statistics (based on new data and Redis data),
result is written to Redis. Also, Flink processes and writes data from Kafka to the Data Warehouse (DWH).
3. **Aggregation:** Real-time processing calculates updated player and vehicle statistics. Once an hour, ETL jobs (managed by Airflow) aggregates data in DWH 
and transfer it to a Clickhouse cluster.
4. **Redis update:** A separate service updates Redis with the latest aggregates from Clickhouse.
5. **Client request:** When a client requests statistics, data is fetched from Redis for minimal latency.

## Key Characteristics

- **Near real-time updates:** Statistics become available within seconds after a battle.
- **Horizontal scalability:** Supports high request load (~10k+ per second).
- **Historical storage:** DWH retains full history and supports analytical reporting.
- **Low-latency serving:** Redis ensures fast delivery of on-demand statistics.

**Main Technologies Used:**  
- **Kafka:** Streaming data transport.
- **Flink:** Real-time aggregation and processing.  
- **Redis:** Low-latency cache and serving layer.
- **Data Warehouse (Snowflake):** Long-term, analytical data storage.
- **Orchestration:** Airflow, Dagster, or Airbyte for ETL management.
