using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LaborEntryApp.Model
{
    public class IndirectProductsModel
    {
        public string name { get; set; } //E.G.: [10005] QC -> 10005
        public string id { get; set; } //id in the products table inside bugzilla database. E.G.: 31
       
    }
}