
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace P9
{
    public partial class PlacementDashboard : Page
    {
        private string ConnectionString
        {
            get
            {
                ConnectionStringSettings settings =
                    ConfigurationManager.ConnectionStrings["PlacementDB"];

                if (settings == null ||
                    string.IsNullOrWhiteSpace(settings.ConnectionString))
                {
                    throw new ConfigurationErrorsException(
                        "Add the PlacementDB connection string to Web.config.");
                }

                return settings.ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    LoadDashboard();
                    LoadStudents("");
                }
                catch (Exception)
                {
                    lblMessage.Text =
                        "Unable to load data. Check Web.config, SQL Server, and the database tables.";
                }
            }
        }

        private void LoadDashboard()
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT
                        COUNT(*) AS TotalStudents,
                        COALESCE(SUM(
                            CASE WHEN IsPlaced = 1
                            THEN 1 ELSE 0 END
                        ), 0) AS PlacedStudents
                    FROM Students";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int total =
                                Convert.ToInt32(reader["TotalStudents"]);

                            int placed =
                                Convert.ToInt32(reader["PlacedStudents"]);

                            lblTotalStudents.Text = total.ToString();
                            lblPlaced.Text = placed.ToString();

                            double percentage = total > 0
                                ? placed * 100.0 / total
                                : 0;

                            lblPercentage.Text =
                                percentage.ToString("F2") + "%";
                        }
                    }
                }
            }
        }

        private void LoadStudents(string search)
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            {
                string query = @"
                    SELECT
                        s.EnrollmentNo,
                        s.StudentName,
                        s.Department,
                        s.PassingYear,
                        s.IsPlaced,
                        p.CompanyName,
                        p.JobRole,
                        p.PackageLPA
                    FROM Students s
                    LEFT JOIN Placements p
                        ON s.StudentId = p.StudentId
                    WHERE
                        s.StudentName LIKE @Search
                        OR s.EnrollmentNo LIKE @Search
                    ORDER BY s.StudentId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Search", SqlDbType.VarChar, 120
                    ).Value = "%" + (search ?? "").Trim() + "%";

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        gvStudents.DataSource = dt;
                        gvStudents.DataBind();

                        if (dt.Rows.Count == 0)
                        {
                            lblMessage.Text =
                                "No matching students found.";
                        }
                        else
                        {
                            lblMessage.Text = "";
                        }
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                LoadStudents(txtSearch.Text);
            }
            catch (Exception)
            {
                lblMessage.Text =
                    "Search failed. Check the database connection and tables.";
            }
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";

            try
            {
                LoadStudents("");
            }
            catch (Exception)
            {
                lblMessage.Text =
                    "Unable to load students. Check the database connection and tables.";
            }
        }
    }
}
