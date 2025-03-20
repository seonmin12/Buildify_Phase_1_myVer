import common.ValidCheck;
import domain.Outbound.controller.OutboundController;
import domain.Outbound.controller.OutboundUserController;
import domain.Outbound.controller.OutboundUserControllerImpl;
import domain.Outbound.repository.OutboundUserRepository;
import domain.Outbound.repository.OutboundUserRepositoryImpl;
import domain.Outbound.service.OutboundUserService;
import domain.Outbound.service.OutboundUserServiceImpl;

import config.Diconfig;
import controller.WarehouseController;

public class Main {
    public static void main(String[] args) {
        Diconfig diconfig = new Diconfig();
        WarehouseController warehouseController = diconfig.warehouseController();
        warehouseController.start();



    }

}
