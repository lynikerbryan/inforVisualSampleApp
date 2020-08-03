## Intro

This is a working application that I developed during my first internship. I am putting it here to give any developer a starting point. Unfortunately, it will not run if you try it locally because this application was made using a private local service at my workplace. Nevertheless, I hope the code is useful for someone.

Most of the useful code is at the file LaborDB - inside DB folder - where it shows how to connect to the API and other stuff.
Please, keep in mind that I removed some sensitive values of key variables/constants such as passwords and usernames. Also, this tool made connections to different databases witch have nothing related to the INFOR VISUAL API.

### If you have any trouble running your project there is list of requirements used by this project:

This is the list of required DLLs to use the API:
- VMFGINVENTORY (VMFGINVENTORY.DLL)
- VMFGSHARED (VMFGSHARED.DLL)
- VMFGSHOPFLOOR (VMFGSHOPFLOOR.DLL)
- LSACORE (LSACORE.DLL)

This is the set of configurration used. To setup this select the project on the Solution Explorer (Visual Studio) then the option should appear.

- Always Start When Debugging: True.
- Anonymous Authentication: Enabled.
- Managed Pipeline Mode: Integrated.
- SSL Enabled: False.
- Windows Authentication: Enabled.

## 1 - GENERAL CONCEPTS 

Before any modification is made on this tool a few concepts are required to better understand how it works.

###TICKETS

First, the entries made by the employees are called tickets and there are two types of it, indirect and direct.

**Indirect**

Indirect tickets do not have any WORK ORDER related to it. If a closer look is made to the LABOR_TICKET table, one column is crucial to determine if a ticket is indirect or direct:  WORKORDER_BASE_ID. This field is NULL for every indirect ticket and the column INDIRECT_ID is always required.

**Direct**

Direct tickets always have a WORK ORDER related to it. In this case, the columns WORKORDER_BASE_ID, WORKORDER_LOT_ID, WORKORDER_SPLIT_ID, WORKORDER_SUB_ID AND OPERATION_SEQ_NO are always required. 

## 2 - CONNECTING/USING TO THE INFOR VISUAL API

**Connecting to the API**

To connect to the API we use the class Dbms calling its method OpenDirect. As the process of getting data from a SQL database you should open, prepare, execute and close the connection.

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
        
To open a connection to the API call the function conOpen. This is a helper function. 

        public static void conOpen()
        {
            Dbms.OpenDirect(instName, provider, "", source, user, password);
        }

**Retrieving data**

The most generic way to get data from the database using the API is using GeneralQuery class. 

        GeneralQuery gen = new GeneralQuery(instName);
        gen.Prepare("WORKORDER", "Select BASE_ID, SUB_ID, PART_ID FROM VMFG.WORK_ORDER WHERE BASE_ID = ?");
        gen.Parameters[0] = baseId;
        gen.Execute();

**Reading returned records**

The data returned after calling method Execute() is stored in the same object used to request it.

        if (gen.Tables["WORKORDER"].Rows.Count > 0)
        {
            for (var i = 0; i <= gen.Tables["WORKORDER"].Rows.Count - 1; i++)
            {
                workOrders.Add(gen.Tables["WORKORDER"].Rows[i]["SUB_ID"].ToString() + " " + gen.Tables["WORKORDER"].Rows[i]["PART_ID"].ToString());
            }

            Dbms.Close(instName);
            return workOrders;
        }
        
**Reading returned records with SQL functions**

In cases where the query contains SQL functions the way to access the returned data changes.

        Model.DatePeriodModel dp = new Model.DatePeriodModel();
        GeneralQuery gen = null;
        gen = new GeneralQuery(instName);
        gen.Prepare("ACCOUNT_PERIOD", "SELECT MIN(BEGIN_DATE) FROM VMFG.ACCOUNT_PERIOD WHERE STATUS = 'A' AND YEAR(BEGIN_DATE) = YEAR(GETDATE()) AND CALENDAR_ID = 'BACH'");
        gen.Execute();

        if (gen.Tables["ACCOUNT_PERIOD"].Rows.Count > 0)
        {
            dp.min = DateTime.Parse(gen.Tables["ACCOUNT_PERIOD"].Rows[0]["Column1"].ToString());
        }

**Saving data**

The are only two occasions where data is being saved on this solution, when saving a new ticket and when saving modifications to an existing ticket. Class LaborDB contains three methods in total related to saving data.

**Saving DIRECT AND INDIRECT tickets**

To save a new ticket we use the class LaborTicket, note that it is required to have a connection instance to the API. For both indirect and direct tickets the process is the same, only differing on the set of information being saved (Check TICKETS information above).

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

**Updating DIRECT and INDIRECT tickets**

To update a ticket we use the class EditLaborTicket. The process is similar as when saving a new ticket. The difference is that to update a ticket its ID is required.
        
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

**Deleting DIRECT and INDIRECT tickets**

To delete a ticket we use the class DeleteLaborTicket. You only need to inform the id of the ticket.

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

