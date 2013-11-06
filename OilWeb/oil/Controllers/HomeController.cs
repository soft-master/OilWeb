using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using oil.Models;
using System.IO;

namespace oil.Controllers
{
    [HandleError]
    public class HomeController : Controller, IDisposable
    {
        private int row_num = 20; //每页显示的数据行数
        public ActionResult Index()
        {
            GuoLuModel[] data_list = null;
            int page = Convert.ToInt16(Request["page"]);//显示第几页
            page = page < 1 ? 1 : page;
            int total_page = 0;
            int total_count = 0;
            using (var context = new gatewayEntities())
            {
                #region 获取数据

                var allData = GetGuoLuModelData(context.BaseInfo, context.Data1);
                total_count = allData.Count();
                data_list = allData.OrderBy(i => i.ShiJian).Skip((page - 1) * row_num).Take(row_num).ToArray();

                #endregion
            }

            
            total_page = total_count % row_num > 0 ? total_count / row_num + 1 : total_count / row_num;
            page = page <= total_page ? page : total_page;

            ViewData["action"] = "";
            ViewData["page"] = page;
            ViewData["last_page"] = (page + 10) >= total_page ? total_page : (page + 10);
            ViewData["total_page"] = total_page;
            ViewData["total_count"] = total_count;
            return View(data_list);
        }

        public ActionResult Detail()
        {
            string shebei_code = Request["code"] ?? "";
            ViewData["shebei_code"] = shebei_code;

            var zqyl_day_list = new List<object>();
            var zqwd_day_list = new List<object>();
            var zqgd_day_list = new List<object>();
            var yqhy_day_list = new List<object>();
            var zqyl_week_list = new List<object>();
            var zqwd_week_list = new List<object>();
            var zqgd_week_list = new List<object>();
            var yqhy_week_list = new List<object>();
            //获取该锅炉的24小时数据
            using (var context = new gatewayEntities())
            {
                var tempDate = DateTime.Now.AddHours(-24);
                var day_list = context.Data1.Where(i => i.ShiJian > tempDate && i.SheBei == shebei_code).OrderBy(i => i.ShiJian).ToList();
                foreach (var guolu in day_list)
                {
                    string temp_str = ((DateTime)guolu.ShiJian).Day.ToString() + "日" + ((DateTime)guolu.ShiJian).Hour + "时";
                    zqyl_day_list.Add(new { x = temp_str, y = guolu.ZQYL02 });
                    zqwd_day_list.Add(new { x = temp_str, y = guolu.ZQWD01 });
                    zqgd_day_list.Add(new { x = temp_str, y = guolu.ZQGD17 });
                    yqhy_day_list.Add(new { x = temp_str, y = guolu.YQHY20 });
                }
            }
            //获取该锅炉的一周数据
            using (var context = new gatewayEntities())
            {
                var tempDate = DateTime.Now.AddDays(-7);
                var week_list = context.Data1.Where(i => i.ShiJian > tempDate && i.SheBei == shebei_code).OrderBy(i => i.ShiJian).ToList();
                foreach (var guolu in week_list)
                {
                    string temp_str = ((DateTime)guolu.ShiJian).Month.ToString() + "月" + ((DateTime)guolu.ShiJian).Day + "日";
                    zqyl_week_list.Add(new { x = temp_str, y = guolu.ZQYL02 });
                    zqwd_week_list.Add(new { x = temp_str, y = guolu.ZQWD01 });
                    zqgd_week_list.Add(new { x = temp_str, y = guolu.ZQGD17 });
                    yqhy_week_list.Add(new { x = temp_str, y = guolu.YQHY20 });
                }
            }
            var seri = new System.Web.Script.Serialization.JavaScriptSerializer();

            var day_arr = new
            {
                xScale = "ordinal",
                type = "line-dotted",
                yScale = "linear",
                main = new List<object>()
                {
                     new { data=zqyl_day_list },
                     new { data=zqwd_day_list },
                     new { data=zqgd_day_list },
                     new { data=yqhy_day_list }
                }
            };
            var week_arr = new
            {
                xScale = "ordinal",
                type = "line-dotted",
                yScale = "linear",
                main = new List<object>()
                {
                     new { data=zqyl_week_list },
                     new { data=zqwd_week_list },
                     new { data=zqgd_week_list },
                     new { data=yqhy_week_list }
                }
            };
            ViewData["day_data"] = seri.Serialize(day_arr);
            ViewData["week_data"] = seri.Serialize(week_arr);
            ViewData["action"] = "detail_data";
            return View();
        }

        public ActionResult Reports()
        {
            string all_str = "全部";
            string Chang = (Request["Chang"] ?? all_str).Trim();
            string Zhan = (Request["Zhan"] ?? all_str).Trim();
            string GuoLu = (Request["GuoLu"] ?? all_str).Trim();
            string Yue = (Request["Yue"] ?? all_str).Trim();
            string Ri = (Request["Ri"] ?? all_str).Trim();
            int page = Convert.ToInt16(Request["page"]);//显示第几页
            page = page < 1 ? 1 : page;
            int total_page = 0;
            int total_count = 0;

            IQueryable<Data1> temp_data_list = null;
            IEnumerable<GuoLuModel> data_list = null;
            List<string> Chang_list = null;
            List<string> Zhan_list = null;
            List<string> GuoLu_list = null;
            List<string> Yue_list = null;
            List<string> Ri_list = null;

            //根据条件查询数据
            using (var context = new gatewayEntities())
            {
                temp_data_list = Chang == all_str ? context.Data1 : context.Data1.Where(i => i.Chang == Chang);
                temp_data_list = Zhan == all_str ? temp_data_list : temp_data_list.Where(i => i.Zhan == Zhan);
                temp_data_list = GuoLu == all_str ? temp_data_list : temp_data_list.Where(i => i.GuoLu == GuoLu);
                temp_data_list = Yue == all_str ? temp_data_list : temp_data_list.Where(i => i.Yue == Yue);
                temp_data_list = Ri == all_str ? temp_data_list : temp_data_list.Where(i => i.Ri == Ri);

                //分页处理
                total_count = temp_data_list.Count();
                total_page = total_count % row_num > 0 ? total_count / row_num + 1 : total_count / row_num;
                page = page <= total_page ? page : total_page;
                temp_data_list = temp_data_list.OrderBy(i => i.ShiJian).Skip((page - 1) * row_num).Take(row_num);
                #region 数据转换
                if (total_count <= 0)
                {
                    data_list = new GuoLuModel[0];
                }
                else
                {
                    data_list = GetGuoLuModelData(context.BaseInfo, temp_data_list);
                }
                #endregion
                //构造查询列表
                Chang_list = context.Data1.Select(i => i.Chang.Trim()).Distinct().ToList();
                Chang_list.Insert(0, all_str);
                Zhan_list = context.Data1.Select(i => i.Zhan.Trim()).Distinct().ToList();
                Zhan_list.Insert(0, all_str);
                GuoLu_list = context.Data1.Select(i => i.GuoLu.Trim()).Distinct().ToList();
                GuoLu_list.Insert(0, all_str);
                Yue_list = context.Data1.Select(i => i.Yue.Trim()).Distinct().ToList();
                Yue_list.Insert(0, all_str);
                Ri_list = context.Data1.Select(i => i.Ri.Trim()).Distinct().ToList();
                Ri_list.Insert(0, all_str);
            }
            ViewData["Chang"] = Chang;
            ViewData["Zhan"] = Zhan;
            ViewData["GuoLu"] = GuoLu;
            ViewData["Yue"] = Yue;
            ViewData["Ri"] = Ri;
            ViewData["Chang_list"] = Chang_list;
            ViewData["Zhan_list"] = Zhan_list;
            ViewData["GuoLu_list"] = GuoLu_list;
            ViewData["Yue_list"] = Yue_list;
            ViewData["Ri_list"] = Ri_list;
            ViewData["action"] = "reports_data";
            ViewData["page"] = page;
            ViewData["last_page"] = (page + 10) >= total_page ? total_page : (page + 10);
            ViewData["total_page"] = total_page;
            ViewData["total_count"] = total_count;
            return View(data_list.ToArray());
        }

        public void OutCsvFile()
        {
            string all_str = "全部";
            string Chang = (Request["Chang"] ?? all_str).Trim();
            string Zhan = (Request["Zhan"] ?? all_str).Trim();
            string GuoLu = (Request["GuoLu"] ?? all_str).Trim();
            string Yue = (Request["Yue"] ?? all_str).Trim();
            string Ri = (Request["Ri"] ?? all_str).Trim();
            IQueryable<Data1> temp_data_list = null;
            IEnumerable<GuoLuModel> data_list = null;
            //根据条件查询数据
            using (var context = new gatewayEntities())
            {
                temp_data_list = Chang == all_str ? context.Data1 : context.Data1.Where(i => i.Chang == Chang);
                temp_data_list = Zhan == all_str ? temp_data_list : temp_data_list.Where(i => i.Zhan == Zhan);
                temp_data_list = GuoLu == all_str ? temp_data_list : temp_data_list.Where(i => i.GuoLu == GuoLu);
                temp_data_list = Yue == all_str ? temp_data_list : temp_data_list.Where(i => i.Yue == Yue);
                temp_data_list = Ri == all_str ? temp_data_list : temp_data_list.Where(i => i.Ri == Ri);
                #region 数据转换
                if (temp_data_list.Count() <= 0)
                {
                    data_list = new GuoLuModel[0];
                }
                else
                {
                    data_list = GetGuoLuModelData(context.BaseInfo, temp_data_list);
                    data_list.OrderBy(i => i.ShiJian);
                }
                #endregion

                //转换成csv文件
                System.Text.StringBuilder result_str = new System.Text.StringBuilder();
                result_str.AppendLine("ID号,状态,设备编号,厂名,站名,锅炉,蒸汽温度℃,烟气含氧量%,蒸汽干度%,蒸汽压力Mpa,给水流量t/h,辐入温度℃,对流入口温度℃,对流出口温度℃,燃油压力Mpa,管壁温度℃,瓦口温度℃,排烟温度℃,燃气累计m3,燃油累计t,水量累计t(燃气时),水量累计t(燃油时),燃气单耗m3/t,燃油单耗m3/t,用电单耗 kw.h/t,用电累计kw.h,鼓风频率,燃油流量t/h,燃气流量m3/h,年,月,日,时间");
                #region 平凑csv字符
                foreach (var data in data_list)
                {
                    result_str.Append(data.id + ",");
                    if (data.ZQYL02 < 5)
                    {
                        result_str.Append("停炉,");
                    }
                    else if (data.ZQYL02 > 5 && data.ZQYL02 < data.Max)
                    {
                        result_str.Append("起炉,");
                    }
                    else
                    {
                        result_str.Append("危险,");
                    }
                    result_str.Append(data.SheBei + ",");
                    result_str.Append(data.Chang + ",");
                    result_str.Append(data.Zhan + ",");
                    result_str.Append(data.GouLu + ",");
                    result_str.Append(data.ZQWD01 + ",");
                    result_str.Append(data.YQHY20 + ",");
                    result_str.Append(data.ZQGD17 + ",");
                    result_str.Append(data.ZQYL02 + ",");
                    result_str.Append(data.GSLL10 + ",");
                    result_str.Append(data.FSWD09 + ",");
                    result_str.Append(data.DRWD08 + ",");
                    result_str.Append(data.DCWD07 + ",");
                    result_str.Append(data.RYYL + ",");
                    result_str.Append(data.GBWD05 + ",");
                    result_str.Append(data.WKWD04 + ",");
                    result_str.Append(data.PYWD03 + ",");
                    result_str.Append(data.RQLJ + ",");
                    result_str.Append(data.RYLJ + ",");
                    result_str.Append(data.SLLJQ + ",");
                    result_str.Append(data.SLLJY + ",");
                    result_str.Append(data.RQDH + ",");
                    result_str.Append(data.RYDH + ",");
                    result_str.Append(data.YDDH + ",");
                    result_str.Append(data.YDLJ + ",");
                    result_str.Append(data.GFPL14 + ",");
                    result_str.Append(data.RYLL16 + ",");
                    result_str.Append(data.RQLJ + ",");
                    result_str.Append(data.Nian + ",");
                    result_str.Append(data.Yue + ",");
                    result_str.Append(data.Ri + ",");
                    result_str.Append(data.ShiJian + ",");
                    result_str.AppendLine();
                }
                #endregion
                Response.AppendHeader("Content-Disposition", "attachment; filename=reports.csv");
                Response.ContentType = "application/ms-excel";
                Response.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312"); // Encoding.UTF8;//
                Response.Write(result_str);
            }

        }

        public ActionResult History()
        {
            string shebei_code = Request["code"] ?? "";
            ViewData["shebei_code"] = shebei_code;
            string start_time = Request["start_time"] ?? DateTime.Now.ToShortDateString();
            string end_time = Request["end_time"] ?? DateTime.Now.AddDays(1).ToShortDateString();
            string Chang = (Request["Chang"] ?? "").Trim();
            string Zhan = (Request["Zhan"] ?? "").Trim();
            string GuoLu = (Request["GuoLu"] ?? "").Trim();
            string ShuXing = (Request["ShuXing"] ?? "").Trim();

            var sx_list = new List<object>();
            List<string> Chang_list = null;
            List<string> Zhan_list = null;
            List<string> GuoLu_list = null;
            Dictionary<string,string> ShuXing_list = null;
            //获取该锅炉的24小时数据
            using (var context = new gatewayEntities())
            {
                System.Data.Objects.ObjectResult<ShuXingData> time_list = null;
                if (!string.IsNullOrEmpty(ShuXing))
                {
                    time_list = context.ExecuteStoreQuery<ShuXingData>("select "+ShuXing+" as ShuXing, ShiJian from Data1 where Chang={0} and Zhan={1} and GuoLu={2} and ShiJian>={3} and ShiJian<{4}", Chang, Zhan, GuoLu, start_time + " 00:00:00", end_time + " 00:00:00");
                }
                if (time_list != null)
                {
                    var tempList = time_list.ToList();
                    foreach (var item in tempList)
                    {
                        string temp_str = ((DateTime)item.ShiJian).Day.ToString() + "日" + ((DateTime)item.ShiJian).Hour + "时";
                        sx_list.Add(new { x = temp_str, y = item.ShuXing });
                    }
                }
                GuoLu_list = context.Data1.Select(i => i.GuoLu.Trim()).Distinct().ToList();

                Chang_list = context.Data1.Select(i => i.Chang.Trim()).Distinct().ToList();
                Zhan_list = context.Data1.Select(i => i.Zhan.Trim()).Distinct().ToList();
                GuoLu_list = context.Data1.Select(i => i.GuoLu.Trim()).Distinct().ToList();
                ShuXing_list = new Dictionary<string, string>();
                #region 属性配置
                ShuXing_list.Add("ZQWD01", "蒸汽温度℃");
                ShuXing_list.Add("YQHY20", "烟气含氧量%");
                ShuXing_list.Add("ZQGD17", "蒸汽干度%");
                ShuXing_list.Add("ZQYL02", "蒸汽压力Mpa");
                ShuXing_list.Add("GSLL10", "给水流量t/h");
                ShuXing_list.Add("FSWD09", "辐入温度℃");
                ShuXing_list.Add("DRWD08", "对流入口温度℃");
                ShuXing_list.Add("DCWD07", "对流出口温度℃");
                ShuXing_list.Add("RYYL", "燃油压力Mpa");
                ShuXing_list.Add("GBWD05", "管壁温度℃");
                ShuXing_list.Add("WKWD04", "瓦口温度℃");
                ShuXing_list.Add("PYWD03", "排烟温度℃");
                ShuXing_list.Add("RQLJ", "燃气累计m3");
                ShuXing_list.Add("RYLJ", "燃油累计t");
                ShuXing_list.Add("SLLJQ", "水量累计t(燃气时)");
                ShuXing_list.Add("SLLJY", "水量累计t(燃油时)");
                ShuXing_list.Add("RQDH", "燃气单耗m3/t");
                ShuXing_list.Add("RYDH", "燃油单耗m3/t");
                ShuXing_list.Add("YDDH", "用电单耗 kw.h/t");
                ShuXing_list.Add("YDLJ", "用电累计kw.h");
                ShuXing_list.Add("GFPL14", "鼓风频率");
                //ShuXing_list.Add("RYLJ", "燃油流量t/h");??????????????????????????????????
                ShuXing_list.Add("RYLL16", "燃气流量m3/h");
                #endregion
            } 
            var seri = new System.Web.Script.Serialization.JavaScriptSerializer();

            var day_arr = new
            {
                xScale = "ordinal",
                type = "line-dotted",
                yScale = "linear",
                main = new List<object>()
                {
                     new { data=sx_list }
                }
            };

            ViewData["Chang"] = Chang;
            ViewData["Zhan"] = Zhan;
            ViewData["GuoLu"] = GuoLu;
            ViewData["ShuXing"] = ShuXing;
            ViewData["time_data"] = seri.Serialize(day_arr);
            ViewData["action"] = "history_data";
            ViewData["Chang_list"] = Chang_list;
            ViewData["Zhan_list"] = Zhan_list;
            ViewData["GuoLu_list"] = GuoLu_list;
            ViewData["ShuXing_list"] = ShuXing_list;
            ViewData["GuoLu"] = GuoLu;
            ViewData["start_time"] = start_time;
            ViewData["end_time"] = end_time;
            return View();
        }

        public void GetZhanList()
        {
            string param = Request["Chang"] ?? "";
            List<string> datas = null;
            string result_str = "";
            using (var context = new gatewayEntities())
            {
                datas = context.Data1.Where(i => i.Chang == param).Select(i => i.Zhan).Distinct().ToList();
            }
            foreach (var item in datas)
            {
                result_str += "<option>" + item + "</option>";
            }
            Response.Write(result_str);
        }


        public void GetGuoLuList()
        {
            string param = Request["Zhan"] ?? "";
            List<string> datas = null;
            string result_str = "";
            using (var context = new gatewayEntities())
            {
                datas = context.Data1.Where(i => i.Zhan == param).Select(i => i.GuoLu).Distinct().ToList();
            }
            foreach (var item in datas)
            {
                result_str += "<option>" + item + "</option>";
            }
            Response.Write(result_str);
        }
        private IEnumerable<GuoLuModel> GetGuoLuModelData(System.Data.Objects.IObjectSet<BaseInfo> base_data, IQueryable<Data1> data1_list)
        {
            var dbResult = (from bdata in base_data
                            join data1 in data1_list
                            on bdata.SheBei equals data1.SheBei
                            select new GuoLuModel
                            {
                                id = data1.id,
                                Chang = bdata.Chang,
                                DCWD07 = data1.DCWD07,
                                DRWD08 = data1.DRWD08,
                                YQHY20 = data1.YQHY20,
                                ZQGD17 = data1.ZQGD17,
                                ZQWD01 = data1.ZQWD01,
                                ZQYL02 = data1.ZQYL02,
                                ShiJian = data1.ShiJian,
                                FSWD09 = data1.FSWD09,
                                GBWD05 = data1.GBWD05,
                                GFPL14 = data1.GFPL14,
                                GouLu = data1.GuoLu,
                                GSLL10 = data1.GSLL10,
                                Nian = data1.Nian,
                                PYWD03 = data1.PYWD03,
                                Ri = data1.Ri,
                                RQDH = data1.RQDH,
                                RQLJ = data1.RQLJ,
                                RYDH = data1.RYDH,
                                RYLJ = data1.RYLJ,
                                RYLL16 = data1.RYLL16,
                                RYYL = data1.RYYL,
                                SheBei = data1.SheBei,
                                SLLJQ = data1.SLLJQ,
                                SLLJY = data1.SLLJY,
                                WKWD04 = data1.WKWD04,
                                YDDH = data1.YDDH,
                                YDLJ = data1.YDLJ,
                                Yue = data1.Yue,
                                Zhan = data1.Zhan,
                                Max = bdata.Max ?? 0
                            }).ToArray();


            var maxids = (from dl in dbResult
                          group dl by dl.GouLu
                              into dlg
                              select new
                              {
                                  dlg.Key,
                                  maxid = dlg.Max(g => g.id)
                              });

            var allData = (from d in dbResult
                           from mi in maxids
                           where d.id == mi.maxid && d.GouLu.Equals(mi.Key)
                           select d);

            return allData;
        }
    }
    class ShuXingData
    {
        public DateTime? ShiJian { get; set; }
        public decimal ShuXing { get; set; }
    }
}
