# PEP: Database Details

This repository contains code to generate database diagrams and other etadata for each schema within the PEP PostgreSQL database.

In database_meta.tbl_foreign_keys, the join_type_1to2 field is defined as follows:
  * INNER - keep only matching records
  * LEFT - keep all records in table_name_1 and only those in table_name_2 that match
  * RIGHT - keep all records in table_name_2 and only those in table_name_1 that match
  * FULL - is not defined for any of the table relationships, but could be used instead of the defined relationships to keep all records in both tables (NULL values will be displayed when there is not a matching record in the other table)

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
