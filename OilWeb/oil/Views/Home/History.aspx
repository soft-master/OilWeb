<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    主页
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<style>
	.search_form{margin:5px 10px;background:#fff;}
	.search_top{border:1px solid #f9f9f9; padding:7px 10px;font-weight:bold;background:#f1f1f1}
	.search_content{padding:10px;border:1px solid #fafafa;padding-left:20px; }
	
	.control-label{width:75px !important; margin-left:0px;}
	.controls{margin-left:10px !important; margin-right:20px;}
	.form-horizontal{overflow:hidden;margin-bottom:5px;}
	.form-horizontal .submit{margin-left:10px;}
	.submit{margin-top:20px; text-align:center}
	
    #chart_time{background:#fff; padding:20px; border:1px solid #dcdce0;margin-top:0px; margin-bottom:20px;}
    .detail h3{margin-left:40px;}
</style>
<div class='search_form'>
    <div class='search_top'>查询</div>
    <div class='search_content'>
        <form action="<%=Url.Content("~/Home/History") %>" method="post" class="form-horizontal" id='search_form'>
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
            </div><br /><br /><br />
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
            <label class="control-label span1">属性</label>
            <div class="controls span2">
                <select name="ShuXing" class='span2'>
                <%
                    Dictionary<string, string> ShuXing_list = (Dictionary<string, string>)ViewData["ShuXing_list"];
                    foreach (var item in ShuXing_list)
                    {
                        string selected = (item.Key == ViewData["ShuXing"].ToString()) ? " selected" : "";
                        Response.Write("<option value=" + item.Key + selected + ">" + item.Value + "</option>");
                    }
                    
                        %>
                </select>
            </div> <br /><br /><br />
            <label class="control-label span1">开始时间</label>
            <div class="controls span2">
                <input type="text" class='datepicker span2' name='start_time' value="<%=ViewData["start_time"]%>" />
            </div>
            <label class="control-label span1">结束时间</label>
            <div class="controls span2">
                <input type="text" class='datepicker span2' name='end_time' value="<%=ViewData["end_time"]%>" />
            </div>
            <div class="controls span2"><br /><br />
            <input type="submit" value='搜索' class="btn submit btn-primary span2"/>
            <input type="hidden" name="page" id="page" value='0' />
            </div>
        </form>
    </div>
</div>
<div class='history bgcfff m10 bw1 bss bcdcdce0'>
    <h3>
        <span>&nbsp;&nbsp;<%=ViewData["start_time"]%>到<%=ViewData["end_time"]%></span>
    </h3>
    <figure style="height: 300px; padding-bottom:40px;" id="chart_time">
    </figure>
</div>
<script>
    $(function () {
        $(".datepicker").datepicker({ format: 'yyyy/mm/dd' });

        var time_data = <%=ViewData["time_data"] %>;
        
        chart_time = new xChart('line-dotted', time_data, '#chart_time', {
            axisPaddingTop: 5,
            timing: 1250
        });

        $('.chang_select').change(function () {
            var Chang = $(this).find("option:selected").val();
            $.get("<%=Url.Content("~/Home/GetZhanList")%>", { Chang: Chang }, function (data) {
                $('.zhan_select').empty().append(data);
                var Zhan = $('.zhan_select').find("option:first").val();
                $.get("<%=Url.Content("~/Home/GetGuoLuList")%>", { Zhan: Zhan }, function (data) {
                    $('.guolu_select').empty().append(data);
                })
            })
        });


        $('.zhan_select').change(function () {
            var Zhan = $(this).find("option:selected").val();
            $.get("<%=Url.Content("~/Home/GetGuoLuList")%>", { Zhan: Zhan }, function (data) {
                $('.guolu_select').empty().append(data);
            })
        });
    })
</script>
</asp:Content>
