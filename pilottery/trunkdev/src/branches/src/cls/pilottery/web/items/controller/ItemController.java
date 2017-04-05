package cls.pilottery.web.items.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.items.form.ItemCheckQueryForm;
import cls.pilottery.web.items.form.ItemDamageQueryForm;
import cls.pilottery.web.items.form.ItemIssueQueryForm;
import cls.pilottery.web.items.form.ItemQuantityQueryForm;
import cls.pilottery.web.items.form.ItemReceiptQueryForm;
import cls.pilottery.web.items.form.ItemTypeDeleteForm;
import cls.pilottery.web.items.form.ItemTypeQueryForm;
import cls.pilottery.web.items.form.NewItemCheckForm;
import cls.pilottery.web.items.form.NewItemDamageForm;
import cls.pilottery.web.items.form.NewItemIssueForm;
import cls.pilottery.web.items.form.NewItemReceiptForm;
import cls.pilottery.web.items.form.ProcItemCheckForm;
import cls.pilottery.web.items.model.ItemCheck;
import cls.pilottery.web.items.model.ItemCheckDetail;
import cls.pilottery.web.items.model.ItemDamage;
import cls.pilottery.web.items.model.ItemIssue;
import cls.pilottery.web.items.model.ItemIssueDetail;
import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.model.ItemReceipt;
import cls.pilottery.web.items.model.ItemReceiptDetail;
import cls.pilottery.web.items.model.ItemType;
import cls.pilottery.web.items.service.ItemCheckService;
import cls.pilottery.web.items.service.ItemDamageService;
import cls.pilottery.web.items.service.ItemIssueService;
import cls.pilottery.web.items.service.ItemQuantityService;
import cls.pilottery.web.items.service.ItemReceiptService;
import cls.pilottery.web.items.service.ItemTypeService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.model.WarehouseManager;
import cls.pilottery.web.warehouses.service.WarehouseService;

@Controller
@RequestMapping("/item")
public class ItemController {
    static Logger logger = Logger.getLogger(ItemController.class);
    
    @Autowired
    private ItemTypeService itemTypeService;
    
    @Autowired
    private ItemReceiptService itemReceiptService;
    
    @Autowired
    private ItemIssueService itemIssueService;
    
    @Autowired
    private ItemQuantityService itemQuantityService;
    
    @Autowired
    private ItemCheckService itemCheckService;
    
    @Autowired
    private ItemDamageService itemDamageService;
    
    @Autowired
    private WarehouseService warehouseService;
    
    
 
	//收到传来的仓库编码，返回可用的仓库管理员信息
	@ResponseBody
	@RequestMapping(params="method=getWarehouseManagerList")
	public List<WarehouseManager> getWarehouseManagerList(HttpServletRequest request, ModelMap model, String warehouseCode) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		userSessionForm.setWarehouseCode(warehouseCode);
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			userSessionForm.setManagerId(0);
		} else {
			userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
			userSessionForm.setManagerId(currentUser.getId().intValue());
		}
		
		List<WarehouseManager> managers = new ArrayList<WarehouseManager>();
		try {
            managers = warehouseService.getWarehouseManagers(userSessionForm);
        } catch (Exception e) {
            logger.error("errmsgs" + e.getMessage());
        }
		
		return managers;
	}
    
	//----------------------Item Type---------------------------------------------//
    
    //物品类别列表查询
    @RequestMapping(params="method=listItemTypes")
    public String listItemTypes(HttpServletRequest request, ModelMap model, @ModelAttribute("itemTypeQueryForm") ItemTypeQueryForm itemTypeQueryForm) throws Exception
    {
        Integer count = itemTypeService.getItemTypeCount(itemTypeQueryForm);
        int pageIndex = PageUtil.getPageIndex(request);
        List<ItemType> itemTypeList = new ArrayList<ItemType>();
        
        if (count != null && count.intValue() != 0) {
            itemTypeQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            itemTypeQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
            
            itemTypeList = itemTypeService.getItemTypeList(itemTypeQueryForm);
        }

        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("itemTypeList", itemTypeList);
        model.addAttribute("itemTypeQueryForm", itemTypeQueryForm);
        
        return LocaleUtil.getUserLocalePath("items/itemTypes/listItemTypes", request);
        //return "items/itemTypes/listItemTypes";
    }
    
    //新增物品类别（页面）
    @RequestMapping(params="method=addItemTypeInit")
    public String addItemTypeInit(HttpServletRequest request, ModelMap model) throws Exception
    {
    	return LocaleUtil.getUserLocalePath("items/itemTypes/addItemType", request);
        //return "items/itemTypes/addItemType";
    }

    //新增物品类别（提交）
    @RequestMapping(params="method=addItemType")
    public String addItemType(HttpServletRequest request, ModelMap model, ItemType itemType) throws Exception
    {
        try {
            logger.info("itemName:" + itemType.getItemName() + ",baseUnitName:" + itemType.getBaseUnitName());
            itemTypeService.addItemType(itemType);
            
            return LocaleUtil.getUserLocalePath("common/successTip", request);
            //return "common/successTip";
        } catch (Exception e) {
            logger.error("errmsgs:" + e.getMessage());
            
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
            //return "common/errorTip";
        }
    	//return "common/errorTip";
    }

    //修改物品类别信息（页面）
    @RequestMapping(params="method=modifyItemTypeInit")
    public String modifyItemTypeInit(HttpServletRequest request, ModelMap model) throws Exception
    {
        String itemCode = request.getParameter("itemCode");
        
        String itemName = request.getParameter("itemName");
        itemName = URLDecoder.decode(URLEncoder.encode(itemName, "ISO-8859-1"), "UTF-8");
        
        String baseUnitName = request.getParameter("baseUnitName");
        baseUnitName = URLDecoder.decode(URLEncoder.encode(baseUnitName, "ISO-8859-1"), "UTF-8");
        
        model.addAttribute("itemCode", itemCode);
        model.addAttribute("itemName", itemName);
        model.addAttribute("baseUnitName", baseUnitName);
        
        return LocaleUtil.getUserLocalePath("items/itemTypes/modifyItemType", request);
        //return "items/itemTypes/modifyItemType";
    }
    
    //修改物品类别信息（提交）
    @RequestMapping(params="method=modifyItemType")
    public String modifyItemType(HttpServletRequest request, ModelMap model, ItemType itemType) throws Exception
    {
        try {
            logger.info("itemCode:" + itemType.getItemCode() + ",itemName:" + itemType.getItemName() + ",baseUnitName:" + itemType.getBaseUnitName());
            itemTypeService.modifyItemType(itemType);
            
            return LocaleUtil.getUserLocalePath("common/successTip", request);
            //return "common/successTip";
        } catch (Exception e) {
            logger.error("errmsgs:" + e.getMessage());
            
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
            //return "common/errorTip";
        }
    	//return "common/errorTip"; 
    }
    
    //删除物品类型信息
    @ResponseBody
    @RequestMapping(params="method=deleteItemType")
    public Map<String, String> deleteItemType(HttpServletRequest request, ModelMap model, ItemTypeDeleteForm itemTypeDeleteForm) throws Exception
    {
    	Map<String, String> json = new HashMap<String, String>();

        try {
            itemTypeService.deleteItemType(itemTypeDeleteForm);
            if (itemTypeDeleteForm.getC_errcode().intValue() == 0)
            {
            	json.put("message", "");
            }
            else
            {
            	json.put("message", itemTypeDeleteForm.getC_errmsg());
            }
        } catch (Exception e) {
            logger.error("errmsgs" + e.getMessage());
            json.put("message", e.getMessage());
        }
        
        return json;
    }
    
   
    
    //----------------------Item Receipt------------------------------------------//
    
	//物品入库信息查询
	@RequestMapping(params="method=listGoodsReceipts")
	public String listItemReceipts(HttpServletRequest request, ModelMap model, @ModelAttribute("itemReceiptQueryForm") ItemReceiptQueryForm itemReceiptQueryForm) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			itemReceiptQueryForm.setSessionOrgCode("00");
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		itemReceiptQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		//获得物品入库记录列表
		Integer count = itemReceiptService.getItemReceiptCount(itemReceiptQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<ItemReceipt> itemReceiptList = new ArrayList<ItemReceipt>();
		
		if (count != null && count.intValue() != 0) {
			itemReceiptQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			itemReceiptQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			itemReceiptList = itemReceiptService.getItemReceiptList(itemReceiptQueryForm);
		}
		
	    model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
	    model.addAttribute("itemReceiptList", itemReceiptList);
	    model.addAttribute("itemReceiptQueryForm", itemReceiptQueryForm);
		
	    return LocaleUtil.getUserLocalePath("items/itemReceipts/listItemReceipts", request);
		//return "items/itemReceipts/listItemReceipts";
	}
	
	//入库详细信息
	@RequestMapping(params="method=itemReceiptDetails")
	public String itemReceiptDetails(HttpServletRequest request, ModelMap model) throws Exception
	{
		String receiptCode = request.getParameter("irNo");
		
		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		String receiptWhName = request.getParameter("receiveWhName");
		receiptWhName = URLDecoder.decode(URLEncoder.encode(receiptWhName, "ISO-8859-1"), "UTF-8");

		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		String createAdminName = request.getParameter("createAdminName");
		createAdminName = URLDecoder.decode(URLEncoder.encode(createAdminName, "ISO-8859-1"), "UTF-8");
		
		model.addAttribute("receiptCode", receiptCode);
		model.addAttribute("receiptWhName", receiptWhName);
		model.addAttribute("createAdminName", createAdminName);
		
		List<ItemReceiptDetail> itemList = new ArrayList<ItemReceiptDetail>();
		itemList = itemReceiptService.getItemReceiptDetails(receiptCode);
		model.addAttribute("itemList", itemList);
		
		return LocaleUtil.getUserLocalePath("items/itemReceipts/itemReceiptDetails", request);
		//return "items/itemReceipts/itemReceiptDetails";
	}
	
	//新增物品入库（页面）
	@RequestMapping(params="method=addItemReceiptInit")
	public String addItemReceiptInit(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			userSessionForm.setManagerId(0);
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		userSessionForm.setManagerId(currentUser.getId().intValue());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		//获得物品列表
		List<ItemType> itemList = new ArrayList<ItemType>();
		itemList = itemTypeService.getItemsForSelect();
		model.addAttribute("itemList", itemList);
		
		return LocaleUtil.getUserLocalePath("items/itemReceipts/addItemReceipt", request);
		//return "items/itemReceipts/addItemReceipt";
	}
	
	//新增物品入库（提交）
	@RequestMapping(params="method=addItemReceipt")
	public String addItemReceipt(HttpServletRequest request, ModelMap model, @ModelAttribute("newItemReceiptForm") NewItemReceiptForm newItemReceiptForm) throws Exception
	{	
		//将list里的空记录删除
		removeEmptyReceiptItem(newItemReceiptForm.getItemDetails());
		
		//如果list为空则返回错误
		if (newItemReceiptForm.getItemDetails().isEmpty())
		{
			//model.addAttribute("system_message", "The item list is empty.");
			//return "common/errorTip";
			model.addAttribute("system_message", "物品列表为空。");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		//如果list里存在重复记录则返回错误
		if (hasDuplicateReceiptItem(newItemReceiptForm.getItemDetails()))
		{
			//model.addAttribute("system_message", "The item list contains duplicate items.");
			//return "common/errorTip";
			model.addAttribute("system_message", "物品列表存在重复的物品记录。");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		try {
			itemReceiptService.addItemReceipt(newItemReceiptForm);
			if (newItemReceiptForm.getC_errcode().intValue() == 0) {
				//model.addAttribute("system_message", "Item receipt <b>" + newItemReceiptForm.getReceiptCode() + "</b> has been successfully created.");
				//return "common/successTip";
				model.addAttribute("system_message", "物品入库记录  <b>" + newItemReceiptForm.getReceiptCode() + "</b> 已成功生成。");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			}
			else {
				logger.error("errmsgs:" + newItemReceiptForm.getC_errmsg());
				model.addAttribute("system_message", newItemReceiptForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
				//return "common/errorTip";
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
    		model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
		}
		//return "common/successTip";
	}
	
	//辅助函数：将list里的空记录删除
	private void removeEmptyReceiptItem(List<ItemReceiptDetail> list)
	{
		for (int i = 0; i < list.size(); i++)
		{
			ItemReceiptDetail rec = list.get(i);
			if (rec.getItemCode() == null || rec.getItemCode() == "")
			{
				list.remove(i);
				i--;
			}
		}
	}
	
	//辅助函数：如果list里存在重复记录则返回错误
	private boolean hasDuplicateReceiptItem(List<ItemReceiptDetail> list)
	{
    	TreeSet<String> set = new TreeSet<String>();
    	for (int i = 0; i < list.size(); i++)
    	{
    		ItemReceiptDetail rec = list.get(i);
    		String str = rec.getItemCode();
    		if (set.contains(str))
    		{
    			return true;
    		}
    		set.add(str);
    	}
    	return false;
	}
	
	//打印入库单
	@RequestMapping(params="method=printItemReceiptSlip")
	public String printItemReceiptSlip(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		StringBuilder operator = new StringBuilder();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			operator.append("Null User");
		} else {
			operator.append(currentUser.getRealName());
    	}
		model.addAttribute("operator", operator);
		
		//操作时间
		Date date = new Date();
		model.addAttribute("date", date);
		
		//入库单编号
		String irNo = request.getParameter("irNo");
		model.addAttribute("irNo", irNo);
		
		//入库机构名称
		String receiveOrgName = request.getParameter("receiveOrgName");
		receiveOrgName = URLDecoder.decode(URLEncoder.encode(receiveOrgName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("receiveOrgName", receiveOrgName);
		
		//入库仓库名称
		String receiveWhName = request.getParameter("receiveWhName");
		receiveWhName = URLDecoder.decode(URLEncoder.encode(receiveWhName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("receiveWhName", receiveWhName);
		
		//入库物品详情信息
		List<ItemReceiptDetail> itemList = new ArrayList<ItemReceiptDetail>();
		itemList = itemReceiptService.getItemReceiptDetails(irNo);
		model.addAttribute("itemList", itemList);
		
		return LocaleUtil.getUserLocalePath("items/itemReceipts/printItemReceiptSlip", request);
		//return "items/itemReceipts/printItemReceiptSlip";
	}
	

	
	//----------------------Item Issue--------------------------------------------//
	
	//物品出库信息查询
	@RequestMapping(params="method=listGoodsIssues")
	public String listItemIssues(HttpServletRequest request, ModelMap model, @ModelAttribute("itemIssueQueryForm") ItemIssueQueryForm itemIssueQueryForm) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			itemIssueQueryForm.setSessionOrgCode("00");
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		itemIssueQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		//获得物品出库信息列表
		Integer count = itemIssueService.getItemIssueCount(itemIssueQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<ItemIssue> itemIssueList = new ArrayList<ItemIssue>();
		
		if (count != null && count.intValue() != 0) {
			itemIssueQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			itemIssueQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			itemIssueList = itemIssueService.getItemIssueList(itemIssueQueryForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("itemIssueList", itemIssueList);
		model.addAttribute("itemIssueQueryForm", itemIssueQueryForm);
		
		return LocaleUtil.getUserLocalePath("items/itemIssues/listItemIssues", request);
		//return "items/itemIssues/listItemIssues";
	}
	
	//出库详细信息
	@RequestMapping(params="method=itemIssueDetails")
	public String itemIssueDetails(HttpServletRequest request, ModelMap model) throws Exception
	{
		String iiNo = request.getParameter("iiNo");
		model.addAttribute("iiNo", iiNo);
		
		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		String operAdminName = request.getParameter("operAdminName");
		operAdminName = URLDecoder.decode(URLEncoder.encode(operAdminName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("operAdminName", operAdminName);
		
		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		String receiveOrgName = request.getParameter("receiveOrgName");
		receiveOrgName = URLDecoder.decode(URLEncoder.encode(receiveOrgName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("receiveOrgName", receiveOrgName);
		
		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		String sendOrgName = request.getParameter("sendOrgName");
		sendOrgName = URLDecoder.decode(URLEncoder.encode(sendOrgName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("sendOrgName", sendOrgName);
		
		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		String sendWhName = request.getParameter("sendWhName");
		sendWhName = URLDecoder.decode(URLEncoder.encode(sendWhName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("sendWhName", sendWhName);
		
		List<ItemIssueDetail> itemList = new ArrayList<ItemIssueDetail>();
		itemList = itemIssueService.getItemIssueDetails(iiNo);
		model.addAttribute("itemList", itemList);
		
		return LocaleUtil.getUserLocalePath("items/itemIssues/itemIssueDetails", request);
		//return "items/itemIssues/itemIssueDetails";
	}
	
	//新增物品出库（页面）
	@RequestMapping(params="method=addItemIssueInit")
	public String addItemIssueInit(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			userSessionForm.setManagerId(0);
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		userSessionForm.setManagerId(currentUser.getId().intValue());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		//获得物品列表
		List<ItemType> itemList = new ArrayList<ItemType>();
		itemList = itemTypeService.getItemsForSelect();
		model.addAttribute("itemList", itemList);
		
		//获得收货机构列表
		List<InfOrgs> orgList = new ArrayList<InfOrgs>();
		orgList = itemIssueService.getReceivingUnitForSelect();
		model.addAttribute("orgList", orgList);
		
		return LocaleUtil.getUserLocalePath("items/itemIssues/addItemIssue", request);
		//return "items/itemIssues/addItemIssue";
	}
	
	//新增物品入库（提交）
	@RequestMapping(params="method=addItemIssue")
	public String addItemIssue(HttpServletRequest request, ModelMap model, @ModelAttribute("newItemIssueForm") NewItemIssueForm newItemIssueForm) throws Exception
	{	
		//将list里的空记录删除
		removeEmptyIssueItem(newItemIssueForm.getItemDetails());
		
		//如果list为空则返回错误
		if (newItemIssueForm.getItemDetails().isEmpty())
		{
			//model.addAttribute("system_message", "The item list is empty.");
			//return "common/errorTip";
			model.addAttribute("system_message", "物品列表为空。");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		//如果list里存在重复记录则返回错误
		if (hasDuplicateIssueItem(newItemIssueForm.getItemDetails()))
		{
			//model.addAttribute("system_message", "The item list contains duplicate items.");
			//return "common/errorTip";
			model.addAttribute("system_message", "物品列表存在重复的物品记录。");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}

		try {
			itemIssueService.addItemIssue(newItemIssueForm);
			if (newItemIssueForm.getC_errcode().intValue() == 0) {
				//model.addAttribute("system_message", "Item issue <b>" + newItemIssueForm.getIssueCode() + "</b> has been successfully created.");
				//return "common/successTip";
				model.addAttribute("system_message", "物品出库记录  <b>" + newItemIssueForm.getIssueCode() + "</b> 已成功生成。");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			}
			else {
				logger.error("errmsgs:" + newItemIssueForm.getC_errmsg());
				model.addAttribute("system_message", newItemIssueForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
				//return "common/errorTip";
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
    		model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
		}
		//return "common/successTip";
	}
	
	//辅助函数：将list里的空记录删除
	private void removeEmptyIssueItem(List<ItemIssueDetail> list)
	{
		for (int i = 0; i < list.size(); i++)
		{
			ItemIssueDetail rec = list.get(i);
			if (rec.getItemCode() == null || rec.getItemCode() == "")
			{
				list.remove(i);
				i--;
			}
		}
	}
	
	//辅助函数：如果list里存在重复记录则返回错误
	private boolean hasDuplicateIssueItem(List<ItemIssueDetail> list)
	{
    	TreeSet<String> set = new TreeSet<String>();
    	for (int i = 0; i < list.size(); i++)
    	{
    		ItemIssueDetail rec = list.get(i);
    		String str = rec.getItemCode();
    		if (set.contains(str))
    		{
    			return true;
    		}
    		set.add(str);
    	}
    	return false;
	}
	
	//打印出库单
	@RequestMapping(params="method=printItemIssueSlip")
	public String printItemIssueSlip(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		StringBuilder operator = new StringBuilder();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			operator.append("Null User");
		} else {
			operator.append(currentUser.getRealName());
    	}
		model.addAttribute("operator", operator);
		
		//操作时间
		Date date = new Date();
		model.addAttribute("date", date);
		
		//出库单编号
		String iiNo = request.getParameter("iiNo");
		model.addAttribute("iiNo", iiNo);
		
		//收货单位名称
		String receiveOrgName = request.getParameter("receiveOrgName");
		receiveOrgName = URLDecoder.decode(URLEncoder.encode(receiveOrgName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("receiveOrgName", receiveOrgName);
		
		//发货单位名称
		String sendOrgName = request.getParameter("sendOrgName");
		sendOrgName = URLDecoder.decode(URLEncoder.encode(sendOrgName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("sendOrgName", sendOrgName);
		
		//发货仓库名称
		String sendWhName = request.getParameter("sendWhName");
		sendWhName = URLDecoder.decode(URLEncoder.encode(sendWhName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("sendWhName", sendWhName);
		
		//入库物品详情信息
		List<ItemIssueDetail> itemList = new ArrayList<ItemIssueDetail>();
		itemList = itemIssueService.getItemIssueDetails(iiNo);
		model.addAttribute("itemList", itemList);
		
		return LocaleUtil.getUserLocalePath("items/itemIssues/printItemIssueSlip", request);
		//return "items/itemIssues/printItemIssueSlip";
	}
	
	
	
	//----------------------Item Inventory Info-----------------------------------//
	
	//物品库存查询
	@RequestMapping(params="method=listInventoryInfo")
	public String listItemInventoryInfo(HttpServletRequest request, ModelMap model, @ModelAttribute("itemQuantityQueryForm") ItemQuantityQueryForm itemQuantityQueryForm) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			itemQuantityQueryForm.setSessionOrgCode("00");
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		itemQuantityQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
    	}
		
		//物品库存列表
		Integer count = itemQuantityService.getItemQuantityCount(itemQuantityQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<ItemQuantity> itemQuantityList = new ArrayList<ItemQuantity>();
		
		if (count != null && count.intValue() != 0) {
			itemQuantityQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			itemQuantityQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			itemQuantityList = itemQuantityService.getItemQuantityList(itemQuantityQueryForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("itemQuantityList", itemQuantityList);
		model.addAttribute("itemQuantityQueryForm", itemQuantityQueryForm);
		
		//选择仓库下拉框
		List<WarehouseInfo> whSelect = new ArrayList<WarehouseInfo>();
		whSelect = itemQuantityService.getStorageWarehouseForSelect(userSessionForm);
		model.addAttribute("whSelect", whSelect);
		
		//选择物品下拉框
		List<ItemType> itemSelect = new ArrayList<ItemType>();
		itemSelect = itemQuantityService.getStorageItemForSelect();
		model.addAttribute("itemSelect", itemSelect);
		
		return LocaleUtil.getUserLocalePath("items/itemInventoryInfo/listInventoryInfo", request);
		//return "items/itemInventoryInfo/listInventoryInfo";
	}
	
	
	
	//----------------------Item Inventory Check----------------------------------//
	
	//物品盘点查询
	@RequestMapping(params="method=listInventoryCheck")
	public String listItemInventoryCheck(HttpServletRequest request, ModelMap model, @ModelAttribute("itemCheckQueryForm") ItemCheckQueryForm itemCheckQueryForm) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			itemCheckQueryForm.setSessionOrgCode("00");
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		itemCheckQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		//物品盘点列表
		Integer count = itemCheckService.getItemCheckCount(itemCheckQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<ItemCheck> itemCheckList = new ArrayList<ItemCheck>();
		
		if (count != null && count.intValue() != 0) {
			itemCheckQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			itemCheckQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			
			itemCheckList = itemCheckService.getItemCheckList(itemCheckQueryForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("itemCheckList", itemCheckList);
		model.addAttribute("itemCheckQueryForm", itemCheckQueryForm);
		
		return LocaleUtil.getUserLocalePath("items/itemInventoryCheck/listInventoryCheck", request);
		//return "items/itemInventoryCheck/listInventoryCheck";
	}
	
	//新增物品盘点（页面）
	@RequestMapping(params="method=addItemCheckInit")
	public String addItemCheckInit(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			userSessionForm.setManagerId(0);
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		userSessionForm.setManagerId(currentUser.getId().intValue());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		return LocaleUtil.getUserLocalePath("items/itemInventoryCheck/addItemCheck", request);
		//return "items/itemInventoryCheck/addItemCheck";
	}
	
	//由仓库编码获得当前仓库下所有在库物品（包括quantity为0的物品）
	@ResponseBody
	@RequestMapping(params="method=getAvailableItemForCheck")
	public List<ItemQuantity> getAvailableItemForCheck(HttpServletRequest request, ModelMap model) throws Exception
	{
		String warehouseCode = request.getParameter("warehouseCode");
		return itemCheckService.getAvailableItemForCheck(warehouseCode);
	}
	
	//新增物品盘点（提交）
	@RequestMapping(params="method=addItemCheck")
	public String addItemCheck(HttpServletRequest request, ModelMap model, @ModelAttribute("newItemCheckForm") NewItemCheckForm newItemCheckForm) throws Exception
	{
		try {
			itemCheckService.addItemCheck(newItemCheckForm);
			if (newItemCheckForm.getC_errcode().intValue() == 0) {
				//model.addAttribute("system_message", "Item check <b>" + newItemCheckForm.getCheckCode() + "</b> has been successfully created.");
				//return "common/successTip";
				model.addAttribute("system_message", "物品盘点 <b>" + newItemCheckForm.getCheckCode() + "</b> 已成功生成。");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			}
			else {
				logger.error("errmsgs:" + newItemCheckForm.getC_errmsg());
				model.addAttribute("system_message", newItemCheckForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
				//return "common/errorTip";
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
    		model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
		}
		//return "common/successTip";
	}
	
	//操作物品盘点（页面）
	@RequestMapping(params="method=processItemCheckInit")
	public String processItemCheckInit(HttpServletRequest request, ModelMap model) throws Exception
	{
		String checkNo = request.getParameter("checkNo");
		model.addAttribute("checkNo", checkNo);
		
		String checkName = request.getParameter("checkName");
		checkName = URLDecoder.decode(URLEncoder.encode(checkName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkName", checkName);
		
		String checkDate = request.getParameter("checkDate");
		model.addAttribute("checkDate", checkDate);
		
		String checkAdmin = request.getParameter("checkAdmin");
		model.addAttribute("checkAdmin", checkAdmin);
		
		String checkAdminName = request.getParameter("checkAdminName");
		checkAdminName = URLDecoder.decode(URLEncoder.encode(checkAdminName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkAdminName", checkAdminName);
		
		String checkWarehouse = request.getParameter("checkWarehouse");
		model.addAttribute("checkWarehouse", checkWarehouse);
		
		String checkWarehouseName = request.getParameter("checkWarehouseName");
		checkWarehouseName = URLDecoder.decode(URLEncoder.encode(checkWarehouseName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkWarehouseName", checkWarehouseName);
		
		String status = request.getParameter("status");
		model.addAttribute("status", status);
		
		List<ItemCheckDetail> itemCheckDetailList = new ArrayList<ItemCheckDetail>();
		itemCheckDetailList = itemCheckService.getItemCheckListDetails(checkNo);
		model.addAttribute("itemCheckDetailList", itemCheckDetailList);
		
		String remark = itemCheckService.getRemarkByCheckNo(checkNo);
		model.addAttribute("remark", remark);
		
		return LocaleUtil.getUserLocalePath("items/itemInventoryCheck/processItemCheck", request);
		//return "items/itemInventoryCheck/processItemCheck";
	}
	
	//操作物品盘点（提交）
	@RequestMapping(params="method=processItemCheck")
	public String processItemCheck(HttpServletRequest request, ModelMap model, @ModelAttribute("procItemCheckForm") ProcItemCheckForm procItemCheckForm) throws Exception
	{
		try {
			itemCheckService.procItemCheck(procItemCheckForm);
			if (procItemCheckForm.getC_errcode().intValue() == 0) {
				//model.addAttribute("system_message", "Item check <b>" + procItemCheckForm.getCheckNo() + "</b> has been successfully processed.");
				//return "common/successTip";
				model.addAttribute("system_message", "物品盘点 <b>" + procItemCheckForm.getCheckNo() + "</b> 操作成功。");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			}
			else {
				logger.error("errmsgs:" + procItemCheckForm.getC_errmsg());
				model.addAttribute("system_message", procItemCheckForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
				//return "common/errorTip";
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
    		model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
		}
		//return "common/successTip";
	}
	
	//完成物品盘点
	@ResponseBody
	@RequestMapping(params="method=completeItemCheck")
	public Map<String, String> completeItemCheck(HttpServletRequest request, ModelMap model) throws Exception
	{
		Map<String, String> json = new HashMap<String, String>();
		
		String checkNo = request.getParameter("checkNo");
		String warehouseCode = request.getParameter("warehouseCode");
		
        try {
            itemCheckService.procCompleteItemCheck(checkNo, warehouseCode);
            json.put("message", "");
        } catch (Exception e) {
            logger.error("errmsgs" + e.getMessage());
            json.put("message", e.getMessage());
        }
        
        return json;
	}
	
	//查看盘点详细信息
	@RequestMapping(params="method=itemCheckDetails")
	public String itemCheckDetails(HttpServletRequest request, ModelMap model) throws Exception
	{
		String checkNo = request.getParameter("checkNo");
		model.addAttribute("checkNo", checkNo);
		
		String checkName = request.getParameter("checkName");
		checkName = URLDecoder.decode(URLEncoder.encode(checkName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkName", checkName);
		
		String checkDate = request.getParameter("checkDate");
		model.addAttribute("checkDate", checkDate);
		
		String checkAdmin = request.getParameter("checkAdmin");
		model.addAttribute("checkAdmin", checkAdmin);
		
		String checkAdminName = request.getParameter("checkAdminName");
		checkAdminName = URLDecoder.decode(URLEncoder.encode(checkAdminName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkAdminName", checkAdminName);
		
		String checkWarehouse = request.getParameter("checkWarehouse");
		model.addAttribute("checkWarehouse", checkWarehouse);
		
		String checkWarehouseName = request.getParameter("checkWarehouseName");
		checkWarehouseName = URLDecoder.decode(URLEncoder.encode(checkWarehouseName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkWarehouseName", checkWarehouseName);
		
		String status = request.getParameter("status");
		model.addAttribute("status", status);
		
		List<ItemCheckDetail> itemCheckDetailList = new ArrayList<ItemCheckDetail>();
		itemCheckDetailList = itemCheckService.getItemCheckListDetails(checkNo);
		model.addAttribute("itemCheckDetailList", itemCheckDetailList);
		
		String remark = itemCheckService.getRemarkByCheckNo(checkNo);
		model.addAttribute("remark", remark);
		
		return LocaleUtil.getUserLocalePath("items/itemInventoryCheck/itemCheckDetails", request);
		//return "items/itemInventoryCheck/itemCheckDetails";
	}
	
	
	//打印盘点单
	@RequestMapping(params="method=printItemCheckSlip")
	public String printItemCheckSlip(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		StringBuilder operator = new StringBuilder();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			operator.append("Null User");
		} else {
			operator.append(currentUser.getRealName());
    	}
		model.addAttribute("operator", operator);
		
		//操作时间
		Date date = new Date();
		model.addAttribute("date", date);
		
		//盘点单编号
		String checkNo = request.getParameter("checkNo");
		model.addAttribute("checkNo", checkNo);
		
		//盘点名称
		String checkName = request.getParameter("checkName");
		checkName = URLDecoder.decode(URLEncoder.encode(checkName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkName", checkName);
		
		//盘点仓库名称
		String checkWarehouseName = request.getParameter("checkWarehouseName");
		checkWarehouseName = URLDecoder.decode(URLEncoder.encode(checkWarehouseName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkWarehouseName", checkWarehouseName);
		
		//盘点物品明细
		List<ItemCheckDetail> itemCheckDetailList = new ArrayList<ItemCheckDetail>();
		itemCheckDetailList = itemCheckService.getItemCheckListDetails(checkNo);
		model.addAttribute("itemCheckDetailList", itemCheckDetailList);
		
		//备注
		String remark = itemCheckService.getRemarkByCheckNo(checkNo);
		model.addAttribute("remark", remark);
		
		return LocaleUtil.getUserLocalePath("items/itemInventoryCheck/printItemCheckSlip", request);
		//return "items/itemInventoryCheck/printItemCheckSlip";
	}
	
	//删除物品盘点
	@ResponseBody
	@RequestMapping(params="method=deleteItemCheck")
	public Map<String, String> deleteItemCheck(HttpServletRequest request, ModelMap model) throws Exception
	{
		Map<String, String> json = new HashMap<String, String>();
		
		String checkNo = request.getParameter("checkNo");
		String warehouseCode = request.getParameter("warehouseCode");
		
		try {
            itemCheckService.procDeleteItemCheck(checkNo, warehouseCode);
            json.put("message", "");
        } catch (Exception e) {
            logger.error("errmsgs" + e.getMessage());
            json.put("message", e.getMessage());
        }
        
        return json;
	}
	
	
	
	//-----------------------Register Damaged Items-------------------------------//
	
	//损毁物品查询
	@RequestMapping(params="method=listDamagedItems")
	public String listDamagedItems(HttpServletRequest request, ModelMap model, @ModelAttribute("itemDamageQueryForm") ItemDamageQueryForm itemDamageQueryForm) throws Exception
	{
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			itemDamageQueryForm.setSessionOrgCode("00");
		} else {
			itemDamageQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
		}
		
		Integer count = itemDamageService.getItemDamageCount(itemDamageQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<ItemDamage> itemDamageList = new ArrayList<ItemDamage>();
		
		if (count != null && count.intValue() != 0) {
			itemDamageQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			itemDamageQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			itemDamageList = itemDamageService.getItemDamageList(itemDamageQueryForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("itemDamageList", itemDamageList);
		model.addAttribute("itemDamageQueryForm", itemDamageQueryForm);
		
		return LocaleUtil.getUserLocalePath("items/itemDamaged/listDamagedItems", request);
		//return "items/itemDamaged/listDamagedItems";
	}
	
	//损毁物品详情
	@RequestMapping(params="method=itemDamageDetails")
	public String itemDamageDetails(HttpServletRequest request, ModelMap model) throws Exception
	{
		String idNo = request.getParameter("idNo");
		model.addAttribute("idNo", idNo);
		
		String damageDate = request.getParameter("damageDate");
		model.addAttribute("damageDate", damageDate);
		
		String itemCode = request.getParameter("itemCode");
		model.addAttribute("itemCode", itemCode);
		
		String itemName = request.getParameter("itemName");
		itemName = URLDecoder.decode(URLEncoder.encode(itemName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("itemName", itemName);
		
		String quantity = request.getParameter("quantity");
		model.addAttribute("quantity", quantity);
		
		String checkAdminName = request.getParameter("checkAdminName");
		checkAdminName = URLDecoder.decode(URLEncoder.encode(checkAdminName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("checkAdminName", checkAdminName);
		
		String remark = request.getParameter("remark");
		remark = URLDecoder.decode(URLEncoder.encode(remark, "ISO-8859-1"), "UTF-8");
		model.addAttribute("remark", remark);
		
		String warehouseCode = request.getParameter("warehouseCode");
		model.addAttribute("warehouseCode", warehouseCode);
		
		String warehouseName = request.getParameter("warehouseName");
		warehouseName = URLDecoder.decode(URLEncoder.encode(warehouseName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("warehouseName", warehouseName);
		
		return LocaleUtil.getUserLocalePath("items/itemDamaged/itemDamageDetails", request);
		//return "items/itemDamaged/itemDamageDetails";
	}
	
	//获得物品在仓库中的库存
	@ResponseBody
	@RequestMapping(params="method=getCurrentQuantity")
	public Integer getCurrentQuantity(HttpServletRequest request, ModelMap model) throws Exception
	{
		String itemCode = request.getParameter("itemCode");
		String warehouseCode = request.getParameter("warehouseCode");
		
		ItemQuantity itemQuantity = new ItemQuantity();
		itemQuantity.setItemCode(itemCode);
		itemQuantity.setWarehouseCode(warehouseCode);
		
		Integer quantity = itemQuantityService.getItemQuantityByWarehouse(itemQuantity);
		if (quantity == null) {
			quantity = 0;
		}
		
		return quantity;
	}
	
	//登记损毁物品（页面）
	@RequestMapping(params="method=addItemDamageInit")
	public String addItemDamageInit(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		UserSessionForm userSessionForm = new UserSessionForm();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			userSessionForm.setSessionOrgCode("00");
			userSessionForm.setManagerId(0);
		} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    		userSessionForm.setManagerId(currentUser.getId().intValue());
    	}
		
		//获得仓库下拉框
		List<WarehouseInfo> whInfoList = new ArrayList<WarehouseInfo>();
		whInfoList = warehouseService.getAvailableWarehouse(userSessionForm);
		model.addAttribute("whInfoList", whInfoList);
		
		//获得物品列表
		List<ItemType> itemList = new ArrayList<ItemType>();
		itemList = itemTypeService.getItemsForSelect();
		model.addAttribute("itemList", itemList);
		
		return LocaleUtil.getUserLocalePath("items/itemDamaged/addItemDamage", request);
		//return "items/itemDamaged/addItemDamage";
	}
	
	//登记损毁物品（提交）
	@RequestMapping(params="method=addItemDamage")
	public String addItemDamage(HttpServletRequest request, ModelMap model, @ModelAttribute("newItemDamageForm") NewItemDamageForm newItemDamageForm) throws Exception
	{
		//获得当前用户Session信息
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			newItemDamageForm.setCheckAdmin(0);
		} else {
			newItemDamageForm.setCheckAdmin(currentUser.getId().intValue());
		}
		
		try {
			itemDamageService.addItemDamage(newItemDamageForm);
			if (newItemDamageForm.getC_errcode().intValue() == 0) {
				//model.addAttribute("system_message", "Item damage record <b>" + newItemDamageForm.getIdNo() + "</b> has been successfully created.");
				//return "common/successTip";
				model.addAttribute("system_message", "物品损毁记录 <b>" + newItemDamageForm.getIdNo() + "</b> 已成功生成。");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				model.addAttribute("system_message", newItemDamageForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
				//return "common/errorTip";
			}
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
		}
		//return "common/successTip";
	}
}
