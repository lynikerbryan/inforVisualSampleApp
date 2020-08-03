using System;
using System.Collections.Generic;
using System.Data.SqlClient;
// API Toolkit Libraries
using Lsa.Data;
using Lsa.Vmfg.Shared;
using Lsa.Vmfg.ShopFloor;

namespace LaborEntryApp.DB
{
    public class LaborDB
    {
        private const string connectionString = "Data Source=WCSSRV0286;Initial Catalog=;User Id=sharept;Password=";
        //connection strings
        private const string provider = "";
        private const string source = "";
        private const string user = "";
        private const string password = "";
        private const string instName = "";

        public static String getUser()
        {
            return user;
        }

        public static String getPassword()
        {
            return password;
        }

        public static String getSource()
        {
            return source;
        }

        public static String getProvider()
        {
            return provider;
        }

        //connect to the database-api
        public static void conOpen()
        {
            Dbms.OpenDirect(instName, provider, "", source, user, password);
        }

        //get the product
        public static Model.WorkOrderModel getWorkOrderId(string baseId, string instance)
        {
            //open con to the api
            conOpen();

            Model.WorkOrderModel wo = new Model.WorkOrderModel();
            string query = "Select BASE_ID, LOT_ID, SPLIT_ID, STATUS FROM VMFG.WORK_ORDER WHERE USER_9 LIKE '%,' + ? + ',%'";

            GeneralQuery gen = null;
            gen = new GeneralQuery(instName);
            gen.Prepare("WORK_ORDER", query);
            gen.Parameters[0] = baseId;
            gen.Execute();

            if (gen.Tables["WORK_ORDER"].Rows.Count > 0)
            {
                wo.baseId = gen.Tables["WORK_ORDER"].Rows[0]["BASE_ID"].ToString();
                wo.lotId = gen.Tables["WORK_ORDER"].Rows[0]["LOT_ID"].ToString();
                wo.splitId = gen.Tables["WORK_ORDER"].Rows[0]["SPLIT_ID"].ToString();
                wo.status = gen.Tables["WORK_ORDER"].Rows[0]["STATUS"].ToString();
            }

            Dbms.Close(instName);
            return wo;
        }

        //get the legs for the product
        public static List<string> getWorkOrderLegs(string baseId, string instance)
        {
            //open con to the api
            conOpen();

            List<string> workOrders = new List<string>();

            GeneralQuery gen = new GeneralQuery(instName);
            gen.Prepare("WORKORDER", "Select BASE_ID, SUB_ID, PART_ID FROM VMFG.WORK_ORDER WHERE BASE_ID = ?");
            gen.Parameters[0] = baseId;
            gen.Execute();

            if (gen.Tables["WORKORDER"].Rows.Count > 0)
            {
                for (var i = 0; i <= gen.Tables["WORKORDER"].Rows.Count - 1; i++)
                {
                    workOrders.Add(gen.Tables["WORKORDER"].Rows[i]["SUB_ID"].ToString() + " " + gen.Tables["WORKORDER"].Rows[i]["PART_ID"].ToString());
                }

                Dbms.Close(instName);
                return workOrders;
            }

            Dbms.Close(instName);
            return workOrders;
        }

        //gets leg 'description'. This is called when loading the tickets for the html table
        public static string getSimpleLeg(string baseId, string subId, string instance)
        {
            //open con to the api
            conOpen();

            string leg = "";
            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("WORKORDER", "Select BASE_ID, SUB_ID, PART_ID FROM VMFG.WORK_ORDER WHERE BASE_ID = ? AND SUB_ID = ?");
            gen.Parameters[0] = baseId;
            gen.Parameters[1] = subId;
            gen.Execute();

            if (gen.Tables["WORKORDER"].Rows.Count > 0)
            {
                for (var i = 0; i <= gen.Tables["WORKORDER"].Rows.Count - 1; i++)
                {
                    leg = gen.Tables["WORKORDER"].Rows[i]["PART_ID"].ToString();
                }
            }
            Dbms.Close(instName);
            return leg;
        }

        //gets opn number (seq number). This is called when loading the tickets fro the html table 
        public static string getSimpleOpn(string baseId, string subId, string instance)
        {
            //open con to the api
            conOpen();

            string opn = "";

            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("OPERATION", "SELECT SEQUENCE_NO, RESOURCE_ID FROM VMFG.OPERATION WHERE WORKORDER_BASE_ID = ? AND WORKORDER_SUB_ID = ?");
            gen.Parameters[0] = baseId;
            gen.Parameters[1] = subId;
            gen.Execute();

            if (gen.Tables["OPERATION"].Rows.Count > 0)
            {
                for (var i = 0; i <= gen.Tables["OPERATION"].Rows.Count - 1; i++)
                {
                    opn = gen.Tables["OPERATION"].Rows[i]["SEQUENCE_NO"].ToString();
                }

                Dbms.Close(instName);
                return opn;
            }

            Dbms.Close(instName);
            return opn;
        }

        //get the seq number/opn for the product/leg
        public static List<string> getSeqNumber(string baseId, string subId, string instance)
        {
            //open con to the api
            conOpen();

            List<string> seqNumbers = new List<string>();

            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("OPERATION", "SELECT SEQUENCE_NO, RESOURCE_ID FROM VMFG.OPERATION WHERE WORKORDER_BASE_ID = ? AND WORKORDER_SUB_ID = ?");
            gen.Parameters[0] = baseId;
            gen.Parameters[1] = subId;
            gen.Execute();

            if (gen.Tables["OPERATION"].Rows.Count > 0)
            {
                for (var i = 0; i <= gen.Tables["OPERATION"].Rows.Count - 1; i++)
                {
                    seqNumbers.Add(gen.Tables["OPERATION"].Rows[i]["SEQUENCE_NO"].ToString() + " " + gen.Tables["OPERATION"].Rows[i]["RESOURCE_ID"].ToString());
                }

                Dbms.Close(instName);
                return seqNumbers;
            }

            Dbms.Close(instName);
            return seqNumbers;
        }

        //get he indirects for the indirect dropdown list
        public static List<string> getIndirectIds(string instance)
        {
            //open con to the api
            conOpen();

            List<string> indProjets = new List<string>();

            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("INDIRECT", "SELECT ID, DESCRIPTION FROM VMFG.INDIRECT");
            gen.Execute();

            if (gen.Tables["INDIRECT"].Rows.Count > 0)
            {
                for (var i = 0; i <= gen.Tables["INDIRECT"].Rows.Count - 1; i++)
                {
                    indProjets.Add(gen.Tables["INDIRECT"].Rows[i]["ID"].ToString() + "-" + gen.Tables["INDIRECT"].Rows[i]["DESCRIPTION"].ToString());
                }

                Dbms.Close(instName);
                return indProjets;
            }

            Dbms.Close(instName);
            return indProjets;
        }

        //loads the indirect when a bugzilla item is indirect
        public static string getSimpleIndirect(string id, string instance)
        {
            //open con to the api
            conOpen();

            string indirect = "";
            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("INDIRECT", "SELECT ID, DESCRIPTION FROM VMFG.INDIRECT WHERE ID = ?");
            gen.Parameters[0] = id;
            gen.Execute();

            if (gen.Tables["INDIRECT"].Rows.Count > 0)
            {
                Dbms.Close(instName);
                return indirect = gen.Tables["INDIRECT"].Rows[0]["ID"].ToString() + "-" + gen.Tables["INDIRECT"].Rows[0]["DESCRIPTION"].ToString();
            }

            Dbms.Close(instName);
            return indirect;
        }

        //list all tickets for specific date
        public static List<Model.LaborTicketModel> listLaborTicket(string date, string employeeId, string instance)
        {
            //open con to the api
            conOpen();

            List<Model.LaborTicketModel> tickets = new List<Model.LaborTicketModel>();

            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("LABOR_TICKET", "SELECT TRANSACTION_ID, WORKORDER_BASE_ID, WORKORDER_LOT_ID, WORKORDER_SPLIT_ID, WORKORDER_SUB_ID, OPERATION_SEQ_NO, RESOURCE_ID, HOURS_WORKED, MULTIPLIER_1, DESCRIPTION, INDIRECT_ID FROM VMFG.LABOR_TICKET WHERE TRANSACTION_DATE = ? AND EMPLOYEE_ID = ?");
            gen.Parameters[0] = date;
            gen.Parameters[1] = employeeId;
            gen.Execute();

            if (gen.Tables["LABOR_TICKET"].Rows.Count > 0)
            {
                for (var i = 0; i <= gen.Tables["LABOR_TICKET"].Rows.Count - 1; i++)
                {
                    Model.LaborTicketModel lt = new Model.LaborTicketModel();
                    lt.ltnum = gen.Tables["LABOR_TICKET"].Rows[i]["TRANSACTION_ID"].ToString();
                    lt.woind = gen.Tables["LABOR_TICKET"].Rows[i]["WORKORDER_BASE_ID"].ToString() + "/" + gen.Tables["LABOR_TICKET"].Rows[i]["WORKORDER_LOT_ID"].ToString() + "/" + gen.Tables["LABOR_TICKET"].Rows[i]["WORKORDER_SPLIT_ID"].ToString();
                    lt.leg = gen.Tables["LABOR_TICKET"].Rows[i]["WORKORDER_SUB_ID"].ToString();
                    lt.seqNum = gen.Tables["LABOR_TICKET"].Rows[i]["OPERATION_SEQ_NO"].ToString();
                    lt.resource = gen.Tables["LABOR_TICKET"].Rows[i]["RESOURCE_ID"].ToString();
                    lt.hoursworked = gen.Tables["LABOR_TICKET"].Rows[i]["HOURS_WORKED"].ToString();
                    lt.overtime = gen.Tables["LABOR_TICKET"].Rows[i]["MULTIPLIER_1"].ToString();
                    lt.description = gen.Tables["LABOR_TICKET"].Rows[i]["DESCRIPTION"].ToString();
                    lt.indirectId = gen.Tables["LABOR_TICKET"].Rows[i]["INDIRECT_ID"].ToString();
                    tickets.Add(lt);
                }

                Dbms.Close(instName);
                return tickets;
            }

            Dbms.Close(instName);
            return tickets;
        }

        //gets the employee ID, first name and last name based on the windows account name
        public static Model.EmployeeModel getEmployeeID(string name, string instance)
        {
            //open con to the 
            conOpen();

            Model.EmployeeModel em = new Model.EmployeeModel();

            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("EMPLOYEE", "SELECT ID, FIRST_NAME, LAST_NAME FROM VMFG.EMPLOYEE WHERE EMAIL_ADDR = ?");
            gen.Parameters[0] = name;
            gen.Execute();

            if (gen.Tables["EMPLOYEE"].Rows.Count > 0)
            {
                em.id = gen.Tables["EMPLOYEE"].Rows[0]["ID"].ToString();
                em.firstname = gen.Tables["EMPLOYEE"].Rows[0]["FIRST_NAME"].ToString();
                em.lastname = gen.Tables["EMPLOYEE"].Rows[0]["LAST_NAME"].ToString();
            }
            Dbms.Close(instName);
            return em;
        }

        //gets the collum RUN_COST_PER_HR
        public static string getHourlyCost(string baseId, string subId, string seqNo, string instance)
        {
            //open con to the api
            conOpen();

            string hc = "";

            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("OPERATION", "SELECT RUN_COST_PER_HR FROM VMFG.OPERATION WHERE WORKORDER_BASE_ID = ? AND WORKORDER_SUB_ID = ? AND SEQUENCE_NO = ?");
            gen.Parameters[0] = baseId;
            gen.Parameters[1] = subId;
            gen.Parameters[2] = Int32.Parse(seqNo);
            gen.Execute();

            if (gen.Tables["OPERATION"].Rows.Count > 0)
            {
                hc = gen.Tables["OPERATION"].Rows[0]["RUN_COST_PER_HR"].ToString();
            }

            Dbms.Close(instName);
            return hc;
        }

        //saves direct ticket into the database
        public static void saveTikect(string bzItem, string baseId, string lotId, string splitId, string leg, string opn, string employeeId, Decimal hourlyCost, string hoursworked, string overtime, string date, string workprod, string task, string premili, string currmili, string comment, string instance)
        {
            //open con to the api
            conOpen();

            //new labor ticket
            LaborTicket ticket = new LaborTicket(instName);
            ticket.Prepare();

            //preparing the data
            DataRow dr = (DataRow)ticket.NewRunLaborRow(1);
            dr["BASE_ID"] = baseId;
            dr["LOT_ID"] = lotId;
            dr["SPLIT_ID"] = splitId;
            dr["SUB_ID"] = leg;
            dr["SEQ_NO"] = Int32.Parse(opn);
            dr["TRANSACTION_TYPE"] = "RUN";
            dr["EMPLOYEE_ID"] = employeeId;
            dr["HOURLY_COST"] = hourlyCost;
            dr["HOURS_WORKED"] = hoursworked;
            dr["MULTIPLIER_1"] = overtime.Equals("OT") ? 1.500 : 1.000;
            dr["TRANSACTION_DATE"] = date;
            bzItem = bzItem.Equals("") ? "-" : "B" + bzItem;
            if (overtime.Equals("OT"))
            {
                dr["DESCRIPTION"] = workprod + "," + task + "," + premili + "," + currmili + "," + bzItem + "," + "OT" + ",&" + comment;
            }
            else if (overtime.Equals("BK"))
            {
                dr["DESCRIPTION"] = workprod + "," + task + "," + premili + "," + currmili + "," + bzItem + "," + "BK" + ",&" + comment;
            }
            else
            {
                dr["DESCRIPTION"] = workprod + "," + task + "," + premili + "," + currmili + "," + bzItem + "," + "" + ",&" + comment;
            }
            dr["SHIFT_DATE"] = date;
            dr["SITE_ID"] = "BACH";

            //api method to save
            try
            {
                ticket.Save();
            }
            catch (Exception ex)
            {
                Dbms.Close(instName);
            }

            Dbms.Close(instName);
        }

        //save indirect ticket into the database
        public static void saveTikectInd(string indirectId, string bzItem, string employeeId, string hoursworked, string overtime, string date, string workprod, string task, string premili, string currmili, string comment, string instance)
        {
            //open con to the api
            conOpen();

            //new labor ticket
            LaborTicket ticket = new LaborTicket(instName);
            ticket.Prepare();

            //preparing the data
            DataRow dr = (DataRow)ticket.NewRunLaborRow(1);
            dr["TRANSACTION_TYPE"] = "INDIRECT";
            dr["EMPLOYEE_ID"] = employeeId;
            dr["HOURS_WORKED"] = hoursworked;
            dr["MULTIPLIER_1"] = overtime.Equals("OT") ? 1.500 : 1.000;
            dr["TRANSACTION_DATE"] = date;
            bzItem = bzItem.Equals("") ? "-" : "B" + bzItem;
            if (overtime.Equals("OT"))
            {
                dr["DESCRIPTION"] = workprod + "," + task + "," + premili + "," + currmili + "," + bzItem + "," + "OT" + ",&" + comment;
            }
            else if (overtime.Equals("BK"))
            {
                dr["DESCRIPTION"] = workprod + "," + task + "," + premili + "," + currmili + "," + bzItem + "," + "BK" + ",&" + comment;
            }
            else
            {
                dr["DESCRIPTION"] = workprod + "," + task + "," + premili + "," + currmili + "," + bzItem + "," + "" + ",&" + comment;
            }
            dr["INDIRECT_ID"] = indirectId;
            dr["SHIFT_DATE"] = date;
            dr["SITE_ID"] = "BACH";

            //api method to save
            try
            {
                ticket.Save();
            }
            catch
            {
                Dbms.Close(instName);
            }

            Dbms.Close(instName);
        }

        //updates one ticket
        public static void updateTicket(Int32 ticketId, string bzItem, string indirectId, string hoursWorked, string overtime, string workProd, string task, string preMili, string currMili, string comment, string instance)
        {
            //open con to the api
            conOpen();

            //new edit labor ticket
            EditLaborTicket editTicket = new EditLaborTicket(instName);
            editTicket.Prepare();

            //preparin the data
            DataRow dr;
            dr = (DataRow)editTicket.NewEditLaborRow(ticketId);
            dr["SITE_ID"] = "BACH";
            dr["INDIRECT_ID"] = indirectId;
            dr["HOURS_WORKED"] = hoursWorked;
            dr["MULTIPLIER_1"] = overtime.Equals("OT") ? 1.500 : 1.000;
            if (overtime.Equals("OT"))
            {
                dr["DESCRIPTION"] = workProd + "," + task + "," + preMili + "," + currMili + "," + bzItem + "," + "OT" + ",&" + comment;
            }
            else if (overtime.Equals("BK"))
            {
                dr["DESCRIPTION"] = workProd + "," + task + "," + preMili + "," + currMili + "," + bzItem + "," + "BK" + ",&" + comment;
            }
            else
            {
                dr["DESCRIPTION"] = workProd + "," + task + "," + preMili + "," + currMili + "," + bzItem + "," + "" + ",&" + comment;
            }

            //api method to save
            try
            {
                editTicket.Save();
            }
            catch
            {
                Dbms.Close(instName);
            }

            Dbms.Close(instName);
        }

        //deletes one ticket
        public static void deleteTicket(Int32 ticketId, string instance)
        {
            //open con to the api
            conOpen();

            //new delete labor ticket
            DeleteLaborTicket deleteTicket = new DeleteLaborTicket(instName);
            deleteTicket.Prepare();

            //preparing the data
            DataRow dr;
            dr = (DataRow)deleteTicket.NewDeleteLaborRow(ticketId);

            //api method to delete
            try
            {
                deleteTicket.Save();
            }
            catch
            {
                Dbms.Close(instName);
            }

            Dbms.Close(instName);
        }

        //gets the date range avaible for new tickets, update and delete
        public static Model.DatePeriodModel getDateRange(string instance)
        {
            //open con to the api
            conOpen();

            Model.DatePeriodModel dp = new Model.DatePeriodModel();
            GeneralQuery gen = null;
            gen = new GeneralQuery(instName);
            gen.Prepare("ACCOUNT_PERIOD", "SELECT MIN(BEGIN_DATE) FROM VMFG.ACCOUNT_PERIOD WHERE STATUS = 'A' AND YEAR(BEGIN_DATE) = YEAR(GETDATE()) AND CALENDAR_ID = 'BACH'");
            gen.Execute();

            if (gen.Tables["ACCOUNT_PERIOD"].Rows.Count > 0)
            {
                dp.min = DateTime.Parse(gen.Tables["ACCOUNT_PERIOD"].Rows[0]["Column1"].ToString());
            }

            gen.Prepare("ACCOUNT_PERIOD", "SELECT MAX(END_DATE) FROM VMFG.ACCOUNT_PERIOD WHERE STATUS = 'A' AND YEAR(END_DATE) = YEAR(GETDATE()) AND CALENDAR_ID = 'BACH'");
            gen.Execute();

            if (gen.Tables["ACCOUNT_PERIOD"].Rows.Count > 0)
            {
                dp.max = DateTime.Parse(gen.Tables["ACCOUNT_PERIOD"].Rows[0]["Column1"].ToString());
            }

            Dbms.Close(instName);
            return dp;
        }

        //check if the date value is really inside the available range
        //this is to avoid CLIENT SIDE manipulation
        public static bool checkDate(string date, string instance)
        {
            //open con to the api
            conOpen();

            //Model.DatePeriodModel dp = new Model.DatePeriodModel();
            GeneralQuery gen = null;
            gen = new GeneralQuery(instName);
            gen.Prepare("ACCOUNT_PERIOD", "SELECT * FROM VMFG.ACCOUNT_PERIOD WHERE ? BETWEEN BEGIN_DATE AND END_DATE AND STATUS = 'A'");
            gen.Parameters[0] = date;
            gen.Execute();

            if (gen.Tables["ACCOUNT_PERIOD"].Rows.Count > 0)
            {
                Dbms.Close(instName);
                return true;
            }

            Dbms.Close(instName);
            return false;
        }

        //check the amount of hours to set overtime and banking options
        public static decimal checkBankingHr(string date, string instance)
        {
            //open con to the api
            conOpen();

            if (date == null)
            {
                date = DateTime.Now.Date.ToString("yyyy-MM-dd");
            }

            decimal hours = 0;
            GeneralQuery gen = null;
            Instance currInstance = Dbms.GetInstanceInfo(instName);
            gen = new GeneralQuery(instance);
            gen.Prepare("LABOR_TICKET", "SELECT SUM(HOURS_WORKED) FROM VMFG.LABOR_TICKET WHERE DateDiff(wk,TRANSACTION_DATE,'" + date + "') = 0 AND SUBSTRING(REVERSE(DESCRIPTION), CHARINDEX(',',REVERSE(DESCRIPTION)) + 1, 2) = 'KB'");
            gen.Execute();

            if (gen.Tables["LABOR_TICKET"].Rows.Count > 0 && !gen.Tables["LABOR_TICKET"].Rows[0]["Column1"].ToString().Equals(""))
            {
                hours = Decimal.Parse(gen.Tables["LABOR_TICKET"].Rows[0]["Column1"].ToString());

                Dbms.Close(instName);
                return hours;
            }

            Dbms.Close(instName);
            return hours;
        }

        //get the last day for the period
        public static DateTime getPeriodLastDay(string instance)
        {
            //open con to the api
            conOpen();

            DateTime dt = new DateTime();
            GeneralQuery gen = null;
            //Instance currInstance = Dbms.GetInstanceInfo(instance);
            gen = new GeneralQuery(instName);
            gen.Prepare("ACCOUNT_PERIOD", "SELECT END_DATE FROM VMFG.ACCOUNT_PERIOD WHERE STATUS = 'A' AND GETDATE() BETWEEN BEGIN_DATE AND END_DATE AND CALENDAR_ID = 'BACH'");
            gen.Execute();

            if (gen.Tables["ACCOUNT_PERIOD"].Rows.Count > 0)
            {
                dt = DateTime.Parse(gen.Tables["ACCOUNT_PERIOD"].Rows[0]["END_DATE"].ToString());
            }

            Dbms.Close(instName);
            return dt;
        }
    }
}