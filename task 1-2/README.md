# Task 1

**Data model diagram:** [WOT_DDS.pdf](https://github.com/Romano-arist/wg/blob/main/task%201-2/WOT_DDS.pdf) ([Miro](https://miro.com/welcomeonboard/TWIrOXhmT3ZvWkVEZCtSS1FSNkh0b2dJM0s3OXF6cG5VeC9NTVJPMUdFb0FIUFBQRWdkb1A3NUorcnU0b1d1MGRBWi84KzBBRlZHQkhjUmhERXdHTGozaTlTYnZ4cHFkdnoxR0ltWlpFdWFqQ1ZaWFUwQS83c3d0QnhJL0dXb3JyVmtkMG5hNDA3dVlncnBvRVB2ZXBnPT0hdjE=?share_link_id=752462169873)).  
*Note: For readability, please download and zoom in on the PDF or use the Miro link provided.*

In this assignment, the decision was made to highlight and describe the DDS (Data Delivery Store) layer for data storage. 
I assumed that raw data originating from source systems is first ingested into the ODS (Operational Data Store) layer. 
The goal in the DDS layer is to process/organize this ODS data effectively.

A **denormalized approach** (using wide fact tables) was intentionally avoided due to several key drawbacks:

- Such structures tend to accumulate redundant information, making it difficult to maintain data integrity and complicating change tracking (for example, updating tank characteristics).
- As more entities, metrics, or business logic changes are introduced, the schema becomes increasingly rigid and difficult to scale.
- Keeping a comprehensive history under this model is inefficient, often leading to duplicate rows and fields that are empty or rarely used.
- Relationships between entities become implicit, raising the risk of turning the storage into an unmanageable "data swamp".

Given these limitations, the Data Vault modeling approach was selected for this project.

**Reasons for choosing Data Vault:**
- Structures information into distinct entities and relationships, minimizing redundancy and easing long-term data management.
- Delivers high flexibility and scalability: new attributes or entities can be incorporated without reworking the core architecture.
- Provides robust change tracking and efficient historical data storage.
- Maintains a transparent structure, clearly mapping business objects and their interconnections.


# Task 2

**Data model diagram:** [WOT_DDS.pdf](https://github.com/Romano-arist/wg/blob/main/task%201-2/WOT_DDS.pdf) ([Miro](https://miro.com/welcomeonboard/TWIrOXhmT3ZvWkVEZCtSS1FSNkh0b2dJM0s3OXF6cG5VeC9NTVJPMUdFb0FIUFBQRWdkb1A3NUorcnU0b1d1MGRBWi84KzBBRlZHQkhjUmhERXdHTGozaTlTYnZ4cHFkdnoxR0ltWlpFdWFqQ1ZaWFUwQS83c3d0QnhJL0dXb3JyVmtkMG5hNDA3dVlncnBvRVB2ZXBnPT0hdjE=?share_link_id=752462169873)).  
*Note: For readability, please download and zoom in on the PDF or use the Miro link provided.*

Given the advantages of the Data Vault flexibility and scalability, it was decided to seamlessly integrate data 
on battle graphics settings into the existing data structure. The up-to-date schema can be reviewed using the links mentioned in Task 1. 
The section containing graphics settings is marked with a **red box** for easier identification.