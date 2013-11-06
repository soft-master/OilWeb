using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace oil.Models
{
    public class GuoLuModel
    {
        public int id;
        public string SheBei;
        public string Chang;
        public string Zhan;
        public string GouLu;

        public decimal? ZQWD01;
        public decimal? ZQGD17;
        public decimal? YQHY20;

        public decimal? ZQYL02;

        public decimal? RYLL16;

        public decimal? GSLL10;

        public decimal? FSWD09;

        public decimal? DRWD08;

        public decimal? DCWD07;

        public decimal? RYYL;

        public decimal? GBWD05;

        public decimal? WKWD04;

        public decimal? PYWD03;

        public decimal? GFPL14;

        public decimal? RQLJ;
        public decimal? RYLJ;

        public decimal? SLLJQ;
        public decimal? SLLJY;

        public decimal? YDLJ;
        public decimal? RQDH;

        public decimal? RYDH;

        public decimal? YDDH;
        public string Nian;
        public string Yue;
        public string Ri;
        public DateTime? ShiJian;

        public int Max;
    }
}
