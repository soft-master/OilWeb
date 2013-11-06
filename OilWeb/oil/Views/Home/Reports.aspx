<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<oil.Models.GuoLuModel[]>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    主页
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<style>
	.reports th, .reports td{text-overflow:ellipsis !important; white-space:nowrap !important; overflow:hidden; padding:10px; background:#fff;}
	.reports th{ background:#eaeaea;}
	.pagination{margin-right:20px;}
	#page_nav{margin-bottom:10px;}
	#page_nav li a{ background:#fafafa;}
	#page_nav li a:hover{ background:#aaa; color:White}
	#page_nav li .active{ background:#aaa; color:White}
	.pagination-title{float:right; margin-top:7px; margin-left:20px;}
	
	.search_form{margin:5px 10px;background:#fafafa;}
	.search_top{border:1px solid #f9f9f9; padding:7px 10px;font-weight:bold;background:#f1f1f1}
	.search_content{padding:10px;border:1px solid #fafafa;padding-left:20px; }
	
	.control-label{width:auto !important; margin-left:0px;}
	.controls{margin-left:10px !important; margin-right:20px;}
	.form-horizontal{overflow:hidden;margin-bottom:5px;}
	.form-horizontal .submit{margin-left:10px;}
</style>
<div class='search_form'>
    <div class='search_top'>查询</div>
    <div class='search_content'>
        <form action="<%=Url.Content("~/Home/Reports") %>"" method="post" class="form-horizontal" id='search_form'>
            <label class="control-label span1">厂名</label>
            <div class="controls span2">
                <select name="Chang" class='span2 chang_select'>
                <%
                    List<string> Chang_list = (List<string>)ViewData["Chang_list"];
                    foreach (var item in Chang_list)
                    {
                        string selected = (item.Trim() == ViewData["Chang"].ToString()) ? " selected" : "";
                        Response.Write("<option value=" + item + selected + ">" + item + "</option>");
                    }
                        %>
                </select>
            </div> 
            <label class="control-label span1">站名</label>
            <div class="controls span2">
                <select name="Zhan" class='span2 zhan_select'>
                <%
                    List<string> Zhan_list = (List<string>)ViewData["Zhan_list"];
                    foreach (var item in Zhan_list)
                    {
                        string selected = (item == ViewData["Zhan"].ToString()) ? " selected" : "";
                        Response.Write("<option value=" + item + selected + ">" + item + "</option>");
                    }
                        %>
                </select>
            </div> 
            <label class="control-label span1">锅炉</label>
            <div class="controls span2">
                <select name="GuoLu" class='span2 guolu_select'>
                <%
                    List<string> GuoLu_list = (List<string>)ViewData["GuoLu_list"];
                    foreach (var item in GuoLu_list)
                    {
                        string selected = (item == ViewData["GuoLu"].ToString()) ? " selected" : "";
                        Response.Write("<option value=" + item + selected + ">" + item + "</option>");
                    }
                        %>
                </select>
            </div>
            <label class="control-label span1">月份</label>
            <div class="controls span2">
                <select name="Yue" class='span2'>
                <%
                    List<string> Yue_list = (List<string>)ViewData["Yue_list"];
                    foreach (var item in Yue_list)
                    {
                        string selected = (item == ViewData["Yue"].ToString()) ? " selected" : "";
                        Response.Write("<option value=" + item + selected + ">" + item + "</option>");
                    }
                        %>
                </select>
            </div>
            <label class="control-label span1">日</label>
            <div class="controls span2">
                <select name="Ri" class='span2'>
                <%
                    List<string> Ri_list = (List<string>)ViewData["Ri_list"];
                    foreach (var item in Ri_list)
                    {
                        string selected = (item == ViewData["Ri"].ToString()) ? " selected" : "";
                        Response.Write("<option value=" + item + selected + ">" + item + "</option>");
                    }
                        %>
                </select>
            </div><br /><br /><br />
            <center>
                <input id='search' type="button" value='搜索' class="btn submit btn-primary span2"/>
                <input id='outcsv' type="button" value='导出文件' class="btn submit btn-inverse span2"/>
                <input type="hidden" name="page" id="page" value='0' />
            </center>
        </form>
    </div>
</div>
<div class="pagination pagination-right" id='page_nav'>
    <div class="pagination-title"><span>共有<font color="#aa0000"><%=ViewData["total_page"] %></font>页,<font color="#aa0000"><%=ViewData["total_count"] %></font>条记录</span></div>
  <ul>
    <li><a href='javascript:;' data-page='<%=Convert.ToInt32(ViewData["page"])-1 %>'>Prev</a></li>
    <%
        for (int i = Convert.ToInt32(ViewData["page"])-5; i <= Convert.ToInt32(ViewData["last_page"]); i++)
        {
            if (i <= 0) continue;
            string class_str = "";
            if (i == Convert.ToInt32(ViewData["page"]))
            {
                class_str = " class='active'"; 
            }

            Response.Write("<li><a" + class_str + " href='javascript:;' data-page='" + i + "'>" + i + "</a></li>");
        }
         %>
    <li><a href='javascript:;' data-page='<%=Convert.ToInt32(ViewData["page"])+1 %>'>Next</a></li>
  </ul>
</div>
<div class='reports bgcfff m10 bw1 bss bcdcdce0'>
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
                var she_bei_link = "<a href='"+ Url.Content("~/Home")+"/Detail?code=" + item.SheBei + "'>" + item.SheBei + "</a>";
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
        $('#page_nav a').click(function () {
            var page = $(this).attr('data-page');
            $('#search_form #page').val(page);
            $('#search_form').submit();
        })
        $('#search').click(function () {
            $('#search_form').attr('action', "<%=Url.Content("~/Home/Reports")%>");
            $('#search_form').submit();
        });
        $('#outcsv').click(function () {
            $('#search_form').attr('action', "<%=Url.Content("~/Home/OutCsvFile")%>");
            $('#search_form').submit();
        });
        var height = document.documentElement.clientHeight - 220;
        $('.reports table').fixedHeaderTable({
            height: height,
            fixedColumns: 1
        });

        $('.chang_select').change(function () {
            var Chang = $(this).find("option:selected").val();
            $.get("<%=Url.Content("~/Home/GetZhanList")%>", { Chang: Chang }, function (data) {
                $('.zhan_select').empty().append("<option>全部</option>" + data);
                $('.guolu_select').empty().append("<option>全部</option>");
            })
        });


        $('.zhan_select').change(function () {
            var Zhan = $(this).find("option:selected").val();
            $.get("<%=Url.Content("~/Home/GetGuoLuList")%>", { Zhan: Zhan }, function (data) {
                $('.guolu_select').empty().append("<option>全部</option>" + data);
            })
        });

    })
</script>
</asp:Content>
