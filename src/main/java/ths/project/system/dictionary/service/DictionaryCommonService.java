package ths.project.system.dictionary.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;

import ths.project.system.dictionary.entity.Dictionary;
import ths.project.system.dictionary.entity.DictionaryTree;
import ths.project.system.dictionary.mapper.DictionaryMapper;
import ths.project.system.dictionary.mapper.DictionaryTreeMapper;

@Service
public class DictionaryCommonService {

	@Autowired
	private DictionaryMapper dictionaryMapper;
	@Autowired
	private DictionaryTreeMapper dictionaryTreeMapper;

	public DictionaryTree getTreeByCode(String treeCode) {
		return dictionaryTreeMapper
				.selectOne(Wrappers.lambdaQuery(DictionaryTree.class).eq(DictionaryTree::getTreeCode, treeCode));
	}

	public List<Dictionary> listByTreeId(String treeId) {
		return dictionaryMapper.selectList(Wrappers.lambdaQuery(Dictionary.class)
				.eq(Dictionary::getDictionaryTreeId, treeId).orderByAsc(Dictionary::getDictionarySort));
	}

	public List<Dictionary> listByTreeCode(String treeCode) {
		DictionaryTree dictionaryTree = this.getTreeByCode(treeCode);
		return this.listByTreeId(dictionaryTree.getTreeId());
	}

	public List<DictionaryTree> childDictionaryTreeListByTreeCode(String treeCode) {
		DictionaryTree dictionaryTreeParent = dictionaryTreeMapper.selectOne(Wrappers.lambdaQuery(DictionaryTree.class)
				.select(DictionaryTree::getTreeId).eq(DictionaryTree::getTreeCode, treeCode));
		return dictionaryTreeMapper.selectList(Wrappers.lambdaQuery(DictionaryTree.class).eq(DictionaryTree::getTreePid,
				dictionaryTreeParent.getTreeId()));
	}
}
