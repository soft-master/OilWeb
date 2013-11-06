<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">
    主页
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<style>
#chart_day, #chart_week{background:#fff; padding:20px; border:1px solid #dcdce0;margin-top:0px; margin-bottom:20px;}
.detail h3{margin-left:40px;}
.line_title{font-size:12px; font-weight:normal;}
.line_color_yl{font-size:7px; border-bottom:3px solid #3880aa;width:1000px;}
.line_color_wd{font-size:7px; border-bottom:3px solid #4da944;width:1000px;}
.line_color_gd{font-size:7px; border-bottom:3px solid #f26522;width:1000px;}
.line_color_hyl{font-size:7px; border-bottom:3px solid #c6080d;width:1000px;}
.color_father{margin-bottom:15px;}
</style>
<div class='detail'>
    <h3>
        <span>24小时内</span>
    </h3>
    <figure style="height: 300px; padding-bottom:40px;" id="chart_day">
        <div class='color_father'>
            <span class='line_title'>蒸汽压力</span>
            <span class='line_color_yl'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span>&nbsp;&nbsp;</span>
            <span class='line_title'>蒸汽温度</span>
            <span class='line_color_wd'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span>&nbsp;&nbsp;</span>
            <span class='line_title'>蒸汽干度</span>
            <span class='line_color_gd'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span>&nbsp;&nbsp;</span>
            <span class='line_title'>烟气含氧量</span>
            <span class='line_color_hyl'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        </div>
    </figure>
    <h3>一周内</h3>
    <figure style="height: 300px; padding-bottom:40px;" id="chart_week">
        <div class='color_father'>
            <span class='line_title'>蒸汽压力</span>
            <span class='line_color_yl'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span>&nbsp;&nbsp;</span>
            <span class='line_title'>蒸汽温度</span>
            <span class='line_color_wd'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span>&nbsp;&nbsp;</span>
            <span class='line_title'>蒸汽干度</span>
            <span class='line_color_gd'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span>&nbsp;&nbsp;</span>
            <span class='line_title'>烟气含氧量</span>
            <span class='line_color_hyl'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        </div>
    </figure>
</div>
<script>
    $(function () {
        var day_data = <%=ViewData["day_data"] %>;
        
        chart_day = new xChart('line-dotted', day_data, '#chart_day', {
            axisPaddingTop: 5,
            timing: 1250
        });

        var week_data = <%=ViewData["week_data"] %>;
        
        chart_week = new xChart('line-dotted', week_data, '#chart_week', {
            axisPaddingTop: 5,
            timing: 1250
        });
    })
</script>
</asp:Content>
