using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;

namespace LaborEntryApp.DB
{
    public class BugzillaDB
    {
        private const string connectionString = @"server=;userid=;
            password=;database=;SslMode=";

        public static String getConString()
        {
            return connectionString;
        }

        public static string getProductId(string bzitem)
        {
            string prodid = "";
            //string cs = getConString();

            MySqlConnection conn = null;
            MySqlDataReader rdr = null;

            try
            {
                conn = new MySqlConnection(connectionString);
                conn.Open();

                string stm = "SELECT product_id FROM bugs WHERE bug_id = @bugid";
                MySqlCommand cmd = new MySqlCommand(stm, conn);
                cmd.Parameters.AddWithValue("@bugid", bzitem);
                rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    //Console.WriteLine(rdr.GetInt32(0) + ": "
                    //   + rdr.GetString(1));
                    prodid = rdr.GetInt32(0).ToString();
                }
                rdr.Close();
                return prodid;
            }
            catch (MySqlException ex)
            {
                //Console.WriteLine("Error: {0}", ex.ToString());
                return "failed";

            }
            finally
            {
                if (rdr != null)
                {
                    rdr.Close();
                }

                if (conn != null)
                {
                    conn.Close();
                }

            }
        }

        public static Model.BugzillaProductModel getProdDescription(string prodId)
        {
            Model.BugzillaProductModel bzProducts = new Model.BugzillaProductModel();

            MySqlConnection conn = null;
            MySqlDataReader rdr = null;

            try
            {
                conn = new MySqlConnection(connectionString);
                conn.Open();

                string stm = "SELECT id, name, description FROM products WHERE id = @id";
                MySqlCommand cmd = new MySqlCommand(stm, conn);
                cmd.Parameters.AddWithValue("@id", prodId);
                rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    bzProducts.id = rdr.GetString(0);
                    bzProducts.name = rdr.GetString(1);
                    bzProducts.description = rdr.GetString(2);
                }
                rdr.Close();
                return bzProducts;
            }
            catch (MySqlException ex)
            {
                return bzProducts;

            }
            finally
            {
                if (rdr != null)
                {
                    rdr.Close();
                }

                if (conn != null)
                {
                    conn.Close();
                }

            }
        }

        public static string getDescription(string prodId)
        {
            string desc = "";
            MySqlConnection conn = null;
            MySqlDataReader rdr = null;

            try
            {
                conn = new MySqlConnection(connectionString);
                conn.Open();

                string stm = "SELECT short_desc FROM bugs WHERE bug_id = @id";
                MySqlCommand cmd = new MySqlCommand(stm, conn);
                cmd.Parameters.AddWithValue("@id", prodId);
                rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    desc = rdr.GetString(0);
                }
                rdr.Close();
                return desc;
            }
            catch (MySqlException ex)
            {
                return desc;

            }
            finally
            {
                if (rdr != null)
                {
                    rdr.Close();
                }

                if (conn != null)
                {
                    conn.Close();
                }
            }
        }

        public static string getEmployeeId(string email)
        {
            string id = "";
            string finalEmail = email + "@wabtec.com";
            MySqlConnection conn = null;
            MySqlDataReader rdr = null;

            try
            {
                conn = new MySqlConnection(connectionString);
                conn.Open();

                string stm = "SELECT userid FROM profiles WHERE LOWER(login_name) = @email";
                MySqlCommand cmd = new MySqlCommand(stm, conn);
                cmd.Parameters.AddWithValue("@email", finalEmail);;
                rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    id = rdr.GetString(0);
                }
            }
            catch (MySqlException ex)
            {

            }
            finally
            {
                if (rdr != null)
                {
                    rdr.Close();
                }

                if (conn != null)
                {
                    conn.Close();
                }
            }
            return id;
        }

        public static bool checkBugModifications(string bugId, string employeeID, DateTime date)
        {
            MySqlConnection conn = null;
            MySqlDataReader rdr = null;

            try
            {
                conn = new MySqlConnection(connectionString);
                conn.Open();
                string stm = "SELECT * FROM longdescs WHERE bug_id = @bug_id AND who = @employee_id AND bug_when >= @date1 AND bug_when <= @date2";
                MySqlCommand cmd = new MySqlCommand(stm, conn);
                cmd.Parameters.AddWithValue("@bug_id", bugId);
                cmd.Parameters.AddWithValue("@employee_id", employeeID);
                cmd.Parameters.AddWithValue("@date1", date.AddDays(-1));
                cmd.Parameters.AddWithValue("@date2", date.AddDays(+2));//adding one more day it only goes until 12:00 AM. so we get 04/08/2018 12:00:00 AM instead of 03/08/2018 12:00:00 AM
                rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    return true;
                }
            }
            catch (MySqlException ex)
            {

            }
            finally
            {
                if (rdr != null)
                {
                    rdr.Close();
                }

                if (conn != null)
                {
                    conn.Close();
                }
            }
            return false;
        }

        public static bool checkCfItemType(string bugId)
        {
            MySqlConnection conn = null;
            MySqlDataReader rdr = null;

            try
            {
                conn = new MySqlConnection(connectionString);
                conn.Open();
                string stm = "SELECT * FROM bugs WHERE bug_id = @bug_id AND cf_itemtype NOT LIKE '% Mtg'";
                MySqlCommand cmd = new MySqlCommand(stm, conn);
                cmd.Parameters.AddWithValue("@bug_id", bugId);
                rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    return true;
                }
            }
            catch (MySqlException ex)
            {

            }
            finally
            {
                if (rdr != null)
                {
                    rdr.Close();
                }

                if (conn != null)
                {
                    conn.Close();
                }
            }
            return false;
        }
    }
}