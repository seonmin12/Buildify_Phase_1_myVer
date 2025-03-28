package domain.Inventory.controller;

import common.ValidCheck;
import domain.Inventory.service.InventoryDeleteService;
import domain.Inventory.service.InventoryReadService;
import dto.InventoryDto;

import java.util.List;

/**
 * 재고 삭제 기능을 구현한 컨트롤러 클래스.
 * <p>
 * 사용자 입력을 받아 재고를 삭제하고 결과를 출력한다.
 */
public class InventoryDeleteControllerImp implements InventoryDeleteController {
    private final InventoryDeleteService inventoryDeleteService;
    private final ValidCheck validCheck;
    private final InventoryReadService inventoryReadService;

    public InventoryDeleteControllerImp(InventoryDeleteService inventoryDeleteService, ValidCheck validCheck, InventoryReadService inventoryReadService) {
        this.inventoryDeleteService = inventoryDeleteService;
        this.validCheck = validCheck;
        this.inventoryReadService = inventoryReadService;
    }


    /**
     * 사용자로부터 재고 정보를 입력받아 해당 재고를 삭제한다.
     * 삭제 전 전체 재고 조회를 통해 정보를 입력할 수 있다.
     * @return 삭제된 재고 정보
     */
    @Override
    public InventoryDto deleteInventory() {
        System.out.println("[재고 삭제]");
        List<InventoryDto> inventoryList = inventoryReadService.ReadAll();
        if(inventoryList == null || inventoryList.isEmpty()){
            System.out.println("현재 등록된 재고가 없습니다.");
            return null;
        }
        System.out.println("\n [현재 재고 목록] ");
        for (InventoryDto dto : inventoryList) {
            System.out.printf("상품명:%-8s | 창고ID:%-6s | 입점사ID:%-6s | 상품ID:%-8s | 재고:%4d | 최종출고일:%s | 최종입고일:%s\n",
                    dto.getProd_name(), dto.getWare_id(), dto.getClient_id(),
                    dto.getProd_id(), dto.getQuantity(), dto.getLast_outbount_day(), dto.getLast_inbound_day());
        }
        System.out.println("===============================================================================");
        System.out.println("삭제할 재고의 상품 ID,client ID, 창고 ID를 입력하세요");
        System.out.print("상품ID를 입력하세요: ");
        String prodID = validCheck.inputAnyString();

        System.out.print("ClientID를 입력하세요: ");
        String clientID = validCheck.inputAnyString();

        System.out.print("창고ID를 입력하세요: ");
        String wareID = validCheck.inputAnyString();

        InventoryDto inventoryDto = inventoryDeleteService.deleteInventory(prodID, clientID, wareID);
        if(inventoryDto != null){
            System.out.println("재고 삭제 성공");


        }else System.out.println("해당 재고를 찾을 수 없습니다.");

        return inventoryDto;


    }
}
