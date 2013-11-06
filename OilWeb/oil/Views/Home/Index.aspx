<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<oil.Models.GuoLuModel[]>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    主页
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<style>
	.status_data_list th, .status_data_list td{text-overflow:ellipsis !important; white-space:nowrap !important; overflow:hidden; padding:10px; background:#fff;}
	.status_data_list th{ background:#eaeaea;}
	.pagination{margin-right:20px;}
	#page_nav{margin-bottom:10px;}
	#page_nav li a{ background:#fafafa;}
	#page_nav li a:hover{ background:#aaa; color:White}
	#page_nav li .active{ background:#aaa; color:White}
	.pagination-title{float:right; margin-top:7px; margin-left:20px;}
</style>
<div class="pagination pagination-right" id='page_nav'>
    <div class="pagination-title"><span>共有<font color="#aa0000"><%=ViewData["total_page"] %></font>页,<font color="#aa0000"><%=ViewData["total_count"] %></font>条记录</span></div>
  <ul>
    <li><a href='/Home/Index?page=<%=Convert.ToInt32(ViewData["page"])-1 %>'>Prev</a></li>
    <%
        for (int i = Convert.ToInt32(ViewData["page"])-5; i <= Convert.ToInt32(ViewData["last_page"]); i++)
        {
            if (i <= 0) continue;
            string class_str = "";
            if (i == Convert.ToInt32(ViewData["page"]))
            {
                class_str = " class='active'"; 
            }

            Response.Write("<li><a" + class_str + " href='/Home/Index?page=" + i + "'>" + i + "</a></li>");
        }
         %>
    <li><a href='/Home/Index?page=<%=Convert.ToInt32(ViewData["page"])+1 %>'>Next</a></li>
  </ul>
</div>
<div class='status_data_list bgcfff m10 bw1 bss bcdcdce0'>
	<table class="table table-striped table-bordered">
        <thead>
		<tr>
			<th>ID号</th>
			<th>状态</th>
			<th>设备编号</th>
			<th>厂名</th>
			<th>站名</th>
			<th>锅炉</th>
			<th>蒸汽温度℃</th>
			<th>烟气含氧量%</th>
			<th>蒸汽干度%</th>
			<th>蒸汽压力Mpa</th>
			<th>给水流量t/h</th>
			<th>辐入温度℃</th>
			<th>对流入口温度℃</th>
			<th>对流出口温度℃</th>
			<th>燃油压力Mpa</th>
			<th>管壁温度℃</th>
			<th>瓦口温度℃</th>
			<th>排烟温度℃</th>
			<th>燃气累计m3</th>
			<th>燃油累计t</th>
			<th>水量累计t(燃气时)</th>
			<th>水量累计t(燃油时)</th>
			<th>燃气单耗m3/t</th>
			<th>燃油单耗m3/t</th>
			<th>用电单耗 kw.h/t</th>
			<th>用电累计kw.h</th>
			<th>鼓风频率</th>
            <th>燃油流量t/h</th>
            <th>燃气流量m3/h</th>
			<th>年</th>
			<th>月</th>
			<th>日</th>
			<th>时间</th>
		</tr>
        </thead>
        <tbody>
        <%
            var open_span = "<span class='label label-success'>起炉</span>";
            var close_span = "<span class='label label-inverse'>停炉</span>";
            var error_span = "<span class='label label-important'>危险</span>";
            foreach (var item in Model)
            {
                if (item.ZQYL02 < 5)
                {
                    Response.Write("<tr>");
                    Response.Write("<td>" + item.id + "</td>");
                    Response.Write("<td>" + close_span + "</td>");
                }
                if (item.ZQYL02 > 5 && item.ZQYL02 < item.Max)
                {
                    Response.Write("<tr>");
                    Response.Write("<td>" + item.id + "</td>");
                    Response.Write("<td>" + open_span + "</td>");
                }
                else if(item.ZQYL02>item.Max)
                {
                    Response.Write("<tr class='error'>");
                    Response.Write("<td>" + item.id + "</td>");
                    Response.Write("<td>" + error_span + "</td>");
                }
                var she_bei_link = "<a href='/Home/Detail?code=" + item.SheBei + "'>" + item.SheBei + "</a>";
                Response.Write("<td>" + she_bei_link + "</td>");
                Response.Write("<td>" + item.Chang + "</td>");
                Response.Write("<td>" + item.Zhan + "</td>");
                Response.Write("<td>" + item.GouLu + "</td>");
                Response.Write("<td>" + item.ZQWD01 + "</td>");
                Response.Write("<td>" + item.YQHY20 + "</td>");
                Response.Write("<td>" + item.ZQGD17 + "</td>");
                Response.Write("<td>" + item.ZQYL02 + "</td>");
                Response.Write("<td>" + item.GSLL10 + "</td>");
                Response.Write("<td>" + item.FSWD09 + "</td>");
                Response.Write("<td>" + item.DRWD08 + "</td>");
                Response.Write("<td>" + item.DCWD07 + "</td>");
                Response.Write("<td>" + item.RYYL + "</td>");
                Response.Write("<td>" + item.GBWD05 + "</td>");
                Response.Write("<td>" + item.WKWD04 + "</td>");
                Response.Write("<td>" + item.PYWD03 + "</td>");

                Response.Write("<td>" + item.RQLJ + "</td>");
                Response.Write("<td>" + item.RYLJ + "</td>");
                Response.Write("<td>" + item.SLLJQ + "</td>");
                Response.Write("<td>" + item.SLLJY + "</td>");
                Response.Write("<td>" + item.RQDH + "</td>");
                Response.Write("<td>" + item.RYDH + "</td>");
                Response.Write("<td>" + item.YDDH + "</td>");
                Response.Write("<td>" + item.YDLJ + "</td>");
                Response.Write("<td>" + item.GFPL14 + "</td>");
                Response.Write("<td>" + item.RYLJ + "</td>");
                Response.Write("<td>" + item.RQLJ + "</td>");

                Response.Write("<td>" + item.Nian + "</td>");
                Response.Write("<td>" + item.Yue + "</td>");
                Response.Write("<td>" + item.Ri + "</td>");
                Response.Write("<td>" + item.ShiJian.ToString() + "</td>");
                Response.Write("</tr>");
            }
         %>
		</tbody>
	</table>
</div>
<script>
    $(function () {
        var height = document.documentElement.clientHeight - 110;
        $('.status_data_list table').fixedHeaderTable({
            height: height,
            fixedColumns: 1
        });
    })
</script>
</asp:Content>
