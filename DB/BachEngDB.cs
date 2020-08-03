using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace LaborEntryApp.DB
{
    public class BachEngDB
    {
        private const string connectionString = "Data Source=BSLSRV0003;Initial Catalog=;User Id=;Password=";

        //gets the work product dropdown list
        public static List<Model.GenericDropDownModel> getWorkProductList()
        {
            List<Model.GenericDropDownModel> gmList = new List<Model.GenericDropDownModel>();
            SqlConnection sqlCnn;
            SqlCommand sqlCmd;
            string sql = null;
            sql = "SELECT VALUE, LABEL FROM VALUE WHERE SOURCE_ID = '1496D7BA33BC49359C6152A4350E1EDC' ORDER BY LABEL";

            sqlCnn = new SqlConnection(connectionString);
            try
            {
                sqlCnn.Open();
                sqlCmd = new SqlCommand(sql, sqlCnn);
                SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                while (sqlReader.Read())
                {
                    Model.GenericDropDownModel gm = new Model.GenericDropDownModel();
                    gm.value = sqlReader.GetValue(0).ToString();
                    gm.label = sqlReader.GetValue(1).ToString();
                    gmList.Add(gm);
                }

                sqlReader.Close();
                sqlCmd.Dispose();
                sqlCnn.Close();
            }
            catch (Exception ex)
            {
                //MessageBox.Show("Can not open connection ! ");
            }
            return gmList;
        }

        //gets the task dropdown list
        public static List<Model.GenericDropDownModel> getTaksList()
        {
            List<Model.GenericDropDownModel> gmList = new List<Model.GenericDropDownModel>();
            SqlConnection sqlCnn;
            SqlCommand sqlCmd;
            string sql = null;
            sql = "SELECT VALUE, LABEL FROM VALUE WHERE SOURCE_ID = 'BB22717E186A45A59FA35B12E26C188D' ORDER BY LABEL";

            sqlCnn = new SqlConnection(connectionString);
            try
            {
                sqlCnn.Open();
                sqlCmd = new SqlCommand(sql, sqlCnn);
                SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                while (sqlReader.Read())
                {
                    Model.GenericDropDownModel gm = new Model.GenericDropDownModel();
                    gm.value = sqlReader.GetValue(0).ToString();
                    gm.label = sqlReader.GetValue(1).ToString();
                    gmList.Add(gm);
                }

                sqlReader.Close();
                sqlCmd.Dispose();
                sqlCnn.Close();
            }
            catch (Exception ex)
            {
                //MessageBox.Show("Can not open connection ! ");
            }
            return gmList;
        }

        //gets the milestone dropdown list
        public static List<Model.GenericDropDownModel> getMilestoneList()
        {
            List<Model.GenericDropDownModel> gmList = new List<Model.GenericDropDownModel>();
            SqlConnection sqlCnn;
            SqlCommand sqlCmd;
            string sql = null;
            sql = "SELECT VALUE, LABEL FROM VALUE WHERE SOURCE_ID = '301F48E0FE6A44BB9636A070120902E8' ORDER BY LABEL";

            sqlCnn = new SqlConnection(connectionString);
            try
            {
                sqlCnn.Open();
                sqlCmd = new SqlCommand(sql, sqlCnn);
                SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                while (sqlReader.Read())
                {
                    Model.GenericDropDownModel gm = new Model.GenericDropDownModel();
                    gm.value = sqlReader.GetValue(0).ToString();
                    gm.label = sqlReader.GetValue(1).ToString();
                    gmList.Add(gm);
                }

                sqlReader.Close();
                sqlCmd.Dispose();
                sqlCnn.Close();
            }
            catch (Exception ex)
            {
                //MessageBox.Show("Can not open connection ! ");
            }
            return gmList;
        }

        ////
        //public static string getYear()
        //{
        //    string year = "";
        //    SqlConnection sqlCnn;
        //    SqlCommand sqlCmd;
        //    string sql = null;
        //    sql = "SELECT CONFIG_ID FROM BUSINESS_CALENDAR_YEAR WHERE YEAR = YEAR(getdate())";

        //    sqlCnn = new SqlConnection(connectionString);
        //    try
        //    {
        //        sqlCnn.Open();
        //        sqlCmd = new SqlCommand(sql, sqlCnn);
        //        SqlDataReader sqlReader = sqlCmd.ExecuteReader();
        //        while (sqlReader.Read())
        //        {
        //            year = sqlReader.GetValue(0).ToString();
                    
        //        }

        //        sqlReader.Close();
        //        sqlCmd.Dispose();
        //        sqlCnn.Close();
        //    }
        //    catch (Exception ex)
        //    {
        //        //MessageBox.Show("Can not open connection ! ");
        //    }
        //    return year;
        //}

        public static List<Model.HolidayModel> getHolidayList()
        {
            List<Model.HolidayModel> list = new List<Model.HolidayModel>();
            SqlConnection sqlCnn;
            SqlCommand sqlCmd;
            string sql = null;
            //sql = "SELECT DAY_DATE, DESCRIPTION FROM BUSINESS_CALENDAR_EXCEPTION WHERE SOURCE_ID = @source_id AND DAY_OFF = '1' ORDER BY DAY_DATE";
            sql = "SELECT DAY_DATE, DATENAME(WEEKDAY, DAY_DATE), DESCRIPTION FROM BUSINESS_CALENDAR_EXCEPTION WHERE DAY_DATE >= getdate() AND DAY_OFF = '1' ORDER BY DAY_DATE";

            sqlCnn = new SqlConnection(connectionString);
            try
            {
                sqlCnn.Open();
                sqlCmd = new SqlCommand(sql, sqlCnn);
                //sqlCmd.Parameters.AddWithValue("@source_id", sourceId);
                SqlDataReader sqlReader = sqlCmd.ExecuteReader();
                while (sqlReader.Read())
                {
                    Model.HolidayModel hl = new Model.HolidayModel();
                    hl.date = sqlReader.GetValue(0).ToString();
                    hl.day = sqlReader.GetValue(1).ToString();
                    hl.description = sqlReader.GetValue(2).ToString();
                    list.Add(hl);
                }

                sqlReader.Close();
                sqlCmd.Dispose();
                sqlCnn.Close();
            }
            catch (Exception ex)
            {
                //MessageBox.Show("Can not open connection ! ");
            }
            return list;
        }
    }
}