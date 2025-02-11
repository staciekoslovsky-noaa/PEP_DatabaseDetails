# PEP Database Diagrams
# S. Koslovsky

# Variables ------------------------------------------------------
schema_of_interest <- 
  #'administrative'
  'acoustics'

# Create functions -----------------------------------------------
# Function to install packages needed
install_pkg <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Install libraries ----------------------------------------------
install_pkg("RPostgreSQL")
install_pkg("dm")

# Run code -------------------------------------------------------

# Update data in DB 
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              password = Sys.getenv("admin_pw"))

# Get tables, foreign keys, and table descriptions from database
tables <- dm::dm_from_con(con, schema = schema_of_interest) %>% 
  dm::dm_select_tbl(starts_with("lku") | starts_with("geo") | starts_with("tbl"))

foreign_keys <- RPostgreSQL::dbGetQuery(con, "SELECT * FROM database_meta.tbl_foreign_keys") %>%
  filter(schema == schema_of_interest)

table_descriptions <- RPostgreSQL::dbGetQuery(con, "SELECT * FROM database_meta.tbl_table_descriptions") %>%
  filter(schema == schema_of_interest) 

# Assign foreign keys to tables dm
for (i in 1:nrow(foreign_keys)) {
  tables <- tables %>%
    dm::dm_add_fk(table = !!foreign_keys$table_name_2[i], columns = !!foreign_keys$field_name_2[i],
                ref_table = !!foreign_keys$table_name_1[i], ref_columns = !!foreign_keys$field_name_1[i]) 
}

# Assign table descriptions to tables dm
for (i in 1:nrow(table_descriptions)) {
  desc <- rlang::set_names(table_descriptions$table_name[i],
                           table_descriptions$table_description[i])
  tables <- tables %>%
    dm::dm_set_table_description(!!desc)
}

# Create dm for drawing diagram
tables_drawn <- tables %>% 
  dm::dm_set_colors(orange = starts_with("lku"), 
                    darkblue = starts_with("geo"), 
                    darkgreen = starts_with("tbl")) %>%
  dm::dm_draw(view_type = "all",
              rankdir = "LR",
              graph_name = paste0("Database Diagram: ", schema_of_interest, " schema"),
              font_size = c(header = 18L, table_description = 12L, column = 15L))

# Print diagram
tables_drawn
