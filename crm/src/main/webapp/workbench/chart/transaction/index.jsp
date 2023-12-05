
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
    /*根据交易表中不同阶段的数量进行一个统计图，最终形成一个漏斗图
    将统计出来的阶段数量比较多的，往上面排列
    将统计出来的阶段数量比较少的，往下面排列

    Sql：

            01 资质审查 10条
            02 需求分析 10条
            03 价值建议 10条
            ....
            07 成交 100

            sql:
                按照阶段分组
                select
                stage,count(*)
                form tbl_tran

                group by stage
     */
%>

<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8" />
    <!-- 引入刚刚下载的 ECharts 文件 -->
    <script src="echarts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <title>Title</title>
    <script >
        $(function (){

            getCharts();

        })
        function getCharts(){

            //图表需要json数据，所以需要发送ajax
            $.ajax({
                url: "workbench/transaction/getCharts.do",
                data: {},
                dataType: "json",
                type: "get",
                success: function (data) {

                    /*
                            max 总条数 既 total
                            data.dataList

                        data:
                            {"total":100,"dataList":[{value:60,name:资质审查,}] }
                     */
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 指定图表的配置项和数据  option就是要画的图
                    var option = {
                        title: {
                            text: '交易漏斗图',
                            subtext:'统计交易数量漏斗图'
                        },toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },


                        legend: {
                            data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                        },
                        series: [
                            {
                                name: '交易漏斗图',
                                type: 'funnel',
                                left: '10%',
                                top: 60,
                                bottom: 60,
                                width: '80%',
                                min: 0,
                                max: 100,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data:data.dataList
                                    // [
                                    /*
                                    { value: 60, name: '01资质审查' },
                                    { value: 40, name: '02需求分析' },
                                    { value: 50, name: '03价值建议' },
                                    { value: 80, name: '06谈判复审' },
                                    { value: 160, name: '07成交' }
                                    */
                                // ]
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            })




        }
    </script>
</head>
<body>
<!-- 为 ECharts 准备一个定义了宽高的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
<script type="text/javascript">


</script>









</body>
</html>
