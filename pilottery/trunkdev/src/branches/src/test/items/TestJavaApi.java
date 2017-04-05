package test.items;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;

import test.BaseTest;

public class TestJavaApi extends BaseTest {
	@Test
	public void test()
	{
		List<Integer> list = new ArrayList<Integer>();
		list.add(10);
		list.add(20);
		list.add(30);
		list.remove(0);
		ListIterator<Integer> iter = list.listIterator();
		while (iter.hasNext())
		{
			System.out.println(iter.nextIndex()+":"+iter.next());
		}
	}
}
