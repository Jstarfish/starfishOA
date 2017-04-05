package cls.pilottery.oms.monitor.dao;

import java.util.List;

import cls.pilottery.oms.monitor.model.GameSalesTrend;
import cls.pilottery.oms.monitor.model.Games;

public interface MGamesDao {

	public int saveGames(Games games);

	public List<Games> queryGames();

	public List<Games> listAllGames(Games games);

	public int listCount(Games game);

	//public int updateGames(GameMsg games);

	public Games findGamesByCode(Long gameCode);

	public List<Games> queryGamePay();

	public List<Games> queryAreaGamePay(Long areaCode);

	public List<GameSalesTrend> queryGameSalesTrend(GameSalesTrend gameSalesTrend);

	public void saveGameSalesTrend(GameSalesTrend gameSalesTrend);

	public List<GameSalesTrend> listAllGameSalesTrend();

	public int clearData();

	public int clearGameSale(String timePoint);

}
