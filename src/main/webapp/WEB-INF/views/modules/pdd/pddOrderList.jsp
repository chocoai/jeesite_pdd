<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/custom.tld"%>
<html>
<head>
    <title>订单管理管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {

        });

        function checkAll(obj) {
            if ($(obj).prop("checked")) {
                $("[name = checkbox]:checkbox").attr("checked", true);
            } else {
                $("[name = checkbox]:checkbox").attr("checked", false);
            }
        }
        
        function delAll() {
            //判断至少写了一项
            var checkedNum = $('input[name="checkbox"]:checked').length;
            if(checkedNum==0){
                alert("请至少选择一项!");
                return false;
            }
            if(confirm("确定删除所选项目?")){
                var checkedList = new Array();
                $("input[name='checkbox']:checked").each(function(){
                    checkedList.push($(this).val());
                });
                $.ajax({
                    type:"POST",
                    url:"${ctx}/pdd/pddOrder/delSelect",
                    data:{"ids":checkedList.toString()},
                    success:function(data){
                        $("[name='checkbox']:checkbox").attr("checked",false);
                        $("[name='checkAll']:checkbox").attr("checked",false);
                        location.reload();//页面刷新
                    },
                    error:function(data){
                        alert('删除失败!');
                    }
                });
            }
        }

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs">
    <li class="active"><a href="${ctx}/pdd/pddOrder/">订单管理列表</a></li>
    <shiro:hasPermission name="pdd:pddOrder:edit">
        <li><a href="${ctx}/pdd/pddOrder/form">订单管理添加</a></li>
    </shiro:hasPermission>
</ul>
<form:form id="searchForm" modelAttribute="pddOrder" action="${ctx}/pdd/pddOrder/" method="post"
           class="breadcrumb form-search">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <ul class="ul-form">
        <li><label>订单编号：</label>
            <form:input path="orderSn" htmlEscape="false" maxlength="30" class="input-medium"/>
        </li>
        <li><label>创建时间：</label>
            <input name="beginCreatedTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${pddOrder.beginCreatedTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> -
            <input name="endCreatedTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${pddOrder.endCreatedTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
        </li>
        <li><label>地址：</label>
            <form:input path="address" htmlEscape="false" maxlength="100" class="input-medium"/>
        </li>
        <li><label>收件人：</label>
            <form:input path="receiverName" htmlEscape="false" maxlength="45" class="input-medium"/>
        </li>
        <li><label>收件人电话：</label>
            <form:input path="receiverPhone" htmlEscape="false" maxlength="45" class="input-medium"/>
        </li>
        <li><label>快递编号：</label>
            <form:input path="trackingNumber" htmlEscape="false" maxlength="45" class="input-medium"/>
        </li>
        <li><label>发货时间：</label>
            <input name="beginShippingTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${pddOrder.beginShippingTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> -
            <input name="endShippingTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${pddOrder.endShippingTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
        </li>
        <li><label>订单类型：</label>
            <form:radiobuttons path="isLucky" items="${fns:getDictList('is_lucky_flag')}" itemLabel="label"
                               itemValue="value" htmlEscape="false"/>
        </li>
        <li><label>发货状态：</label>
            <form:radiobuttons path="orderStatus" items="${fns:getDictList('order_status')}" itemLabel="label"
                               itemValue="value" htmlEscape="false"/>
        </li>
        <li><label>退款状态：</label>
            <form:radiobuttons path="refundStatus" items="${fns:getDictList('refund_status')}" itemLabel="label"
                               itemValue="value" htmlEscape="false"/>
        </li>
        <li><label>所属平台：</label>
            <form:select path="pddPlatform.id" class="input-mini">
                <form:option value="" label="全部平台" htmlEscape="false"/>
                <form:options items="${pddPlatformList}" itemLabel="shopName" itemValue="id" htmlEscape="false"/>
            </form:select>
        </li>

        <li><label>快递公司：</label>
            <form:select path="pddLogistics.logisticsId" class="input-mini">
                <form:option value="" label="全部快递公司" htmlEscape="false"/>
                <form:options items="${pddLogisticses}" itemLabel="logisticsCompany" itemValue="logisticsId" htmlEscape="false"/>
            </form:select>
        </li>
        <li><label>最后更新：</label>
            <input name="beginUpdatedAt" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${pddOrder.beginUpdatedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> -
            <input name="endUpdatedAt" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${pddOrder.endUpdatedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
        </li>
        <li><label>包裹状态：</label>
            <form:select path="packageStatus" class="input-medium">
                <form:option value="" label="请选择" htmlEscape="false"/>
                <form:options items="${fns:getDictList('package_status')}" itemLabel="label" itemValue="value"
                              htmlEscape="false"/>
            </form:select>
        </li>
        <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
            <input id="btnDelete" class="btn btn-primary" type="button" onclick="delAll()" value="删除选中"/>
        </li>
    </ul>
</form:form>
<sys:message content="${message}"/>


<table id="contentTable" class="table table-striped table-bordered table-condensed">

    <thead>
    <tr>
        <td align="center"><input type="checkbox" name="checkAll" onchange="checkAll(this)" /></td>
        <th>所属平台</th>
        <th>快递公司</th>
        <th>快递编号</th>
        <th>订单编号</th>
        <th>发货时间</th>
        <th>预警倒计时</th>
        <%--	<th>创建时间</th>--%>
        <%--<th>地址</th>--%>
        <th>收件人</th>
        <th>收件人电话</th>


        <th>发货状态</th>
        <%--	<th>退款状态</th>--%>

        <%--	<th>最后更新时间</th>--%>
        <th>包裹状态</th>
        <th>更新时间</th>
        <shiro:hasPermission name="pdd:pddOrder:edit">
            <th>操作</th>
        </shiro:hasPermission>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.list}" var="pddOrder">
        <tr>
            <td align="center"><input type="checkbox" name="checkbox" value="${pddOrder.id}"></td>
            <td><a href="${ctx}/pdd/pddOrder/form?id=${pddOrder.id}">
                    ${pddOrder.pddPlatform.shopName}</a>
            </td>
            <td>
                    ${pddOrder.pddLogistics.logisticsCompany}
            </td>
            <td>
                    ${pddOrder.trackingNumber}
            </td>

            <td>
                    ${pddOrder.orderSn}
            </td>
            <td>
                <fmt:formatDate value="${pddOrder.shippingTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </td>
            <td>
                <c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>

                <c:choose>
                    <c:when test="${pddOrder.packageStatus== 0 ||
                    pddOrder.packageStatus== 1 ||
                    pddOrder.packageStatus== 2||
                    pddOrder.packageStatus== 201}">
                        <c:choose>
                            <c:when test="${pddOrder.packageStatus== 0}">
                                <span style="color:red" >揽件：<ct:Time type="SECOND" diff="${user.pullRemand*1000*60*60-(nowDate-pddOrder.shippingTime.time)}"/></span>
                            </c:when>
                            <c:otherwise>
                                <span style="color:red" >中转:<ct:Time type="SECOND" diff="${user.secondRemand*1000*60*60-(nowDate-pddOrder.updatedAt.time)}"/></span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${pddOrder.packageStatus== 4}">
                                异常件
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${pddOrder.packageStatus== 3}">
                                        已签收
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </td>

                <%--<td>
                    <fmt:formatDate value="${pddOrder.createdTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>--%>
                <%--<td>
                        ${pddOrder.address}
                </td>--%>
            <td>
                    ${pddOrder.receiverName}
            </td>
            <td>
                    ${pddOrder.receiverPhone}
            </td>


            <td>
                    ${fns:getDictLabel(pddOrder.orderStatus, 'order_status', '')}
            </td>
                <%--<td>
                    ${fns:getDictLabel(pddOrder.refundStatus, 'refund_status', '')}
                </td>--%>

                <%--<td>
                    <fmt:formatDate value="${pddOrder.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>--%>
            <td>
                    ${fns:getDictLabel(pddOrder.packageStatus, 'package_status', '')}
            </td>
            <td>
                <fmt:formatDate value="${pddOrder.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </td>
            <shiro:hasPermission name="pdd:pddOrder:edit">
                <td>
                    <a href="${ctx}/pdd/pddOrder/express?id=${pddOrder.id}"><img src="${ctxStatic}/images/sync.png" alt="刷新快递" title="刷新快递"></a>
                    <a href="${ctx}/pdd/pddOrder/form?id=${pddOrder.id}">修改</a>
                    <a href="${ctx}/pdd/pddOrder/view?id=${pddOrder.id}">查看</a>
                    <a href="${ctx}/pdd/pddOrder/delete?id=${pddOrder.id}"
                       onclick="return confirmx('确认要删除该订单管理吗？', this.href)">删除</a>
                </td>
            </shiro:hasPermission>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div class="pagination">${page}</div>
</body>
</html>